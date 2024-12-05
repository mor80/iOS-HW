import EventKit

protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> Bool
}

struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

final class CalendarManager: CalendarManaging {
    private let eventStore = EKEventStore()

    // MARK: - Синхронный метод создания события
    func create(eventModel: CalendarEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()

        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }

        group.wait()
        return result
    }

    // MARK: - Асинхронный метод создания события
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] granted, error in
            guard granted, error == nil, let self = self else {
                print("Access denied or error occurred: \(String(describing: error))")
                completion?(false)
                return
            }

            // Создаем событие
            let event = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(event, span: .thisEvent)
                print("Event successfully added to calendar: \(event.title ?? "Unknown title")")
                completion?(true)
            } catch let error as NSError {
                print("Failed to save event with error: \(error)")
                completion?(false)
            }
        }

        // Запрашиваем доступ к календарю
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
