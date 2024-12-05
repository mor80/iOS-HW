# iOS-HW

Здесь все домашки начиная со 2. Все вариации в комитах

# iOS-HW2
Homework 2

## Вопросы и ответы

### 1. What issues prevent us from using storyboards in real projects?

В реальных проектах часто отказываются от сторибордов по следующим причинам:

- **Проблемы с масштабируемостью**: В крупных проектах с множеством экранов сториборды становятся трудными для навигации и управления.
- **Отсутствие гибкости**: Кодовый подход позволяет создавать интерфейсы динамически и легче адаптировать их под изменения.
- **Меньший контроль над жизненным циклом **: Сториборды скрывают некоторые детали реализации, что может влиять на производительность и усложнять отладку.

---
```swift
private func configureUI() {
    view.backgroundColor = .systemPink

    configureTitle()
}

private func configureTitle() {
    let title = UILabel() // make it a private field titleView above viewDidLoad()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.text = "WishMaker"
    title.font = UIFont.systemFont(ofSize: 32)
    
    view.addSubview(title)
    NSLayoutConstraint.activate([
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
    ])
}
```
---

### 2. What does the code on lines 25 and 29 do?

- **Строка 25** (`title.translatesAutoresizingMaskIntoConstraints = false`): Отключает автоматическое преобразование autoresizing masks в ограничения Auto Layout для `UILabel`. Это нужно, чтобы использовать собственные ограничения (constraints) для `UILabel`.
- **Строка 29** (`view.addSubview(title)`): Добавляет `UILabel` (`title`) как Subview к основному представлению (`view`). Это позволяет отображать элемент на экране и применять к нему ограничения.

---

### 3. Что такое Safe Area Layout Guide?

**Safe Area Layout Guide** — это область экрана, которая не перекрывается системными элементами, такими как статус-бар, индикатор домой, или навигационные панели. Она используется для того, чтобы элементы интерфейса располагались корректно и не пересекались с этими системными компонентами.

---
```swift
private func configureSliders() {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    view.addSubview(stack)
    stack.layer.cornerRadius = 20
    stack.clipsToBounds = true

    let sliderRed = CustomSlider(title: "Red", min: 0, max: 1)
    let sliderBlue = CustomSlider(title: "Blue", min: 0, max: 255)
    let sliderGreen = CustomSlider(title: "Green", min: 0, max: 255)

    for slider in [sliderRed, sliderBlue, sliderGreen] {
        stack.addArrangedSubview(slider)
    }

    NSLayoutConstraint.activate([
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
    ])

    sliderRed.valueChanged = { [weak self] value in
        self?.view.backgroundColor = ...
    }
}
```
---

### 4. What is `[weak self]` on line 23 and why it is important?

**`[weak self]`** используется для предотвращения создания сильной циклической ссылки (retain cycle) внутри замыкания (`closure`). В данном случае замыкание отслеживает изменение значения слайдера и изменяет цвет фона `view`. Без `[weak self]` `self` (контроллер) удерживался бы в памяти замыканием, что привело бы к утечке памяти. С `[weak self]`, замыкание не создает сильной ссылки на контроллер, и он может быть корректно удален из памяти, если больше не нужен.

---

### 5. What does `clipsToBounds` mean?

**`clipsToBounds = true`** указывает, что все Subview, которые выходят за пределы видимых границ `stack`, будут обрезаны (не будут видимы). Это особенно важно, если у `stack` есть закругленные углы, так как эта настройка ограничивает содержимое `UIStackView` границами самого `stack`.

---

### 6. What is the `valueChanged` type? What is `Void` and what is `Double`?

- **`valueChanged`** — это замыкание, с типом `(Double) -> Void`.
- **`Double`** — тип данных, представляющий значение слайдер.
- **`Void`** — возвращаемый тип замыкания, который указывает на то, что замыкание ничего не возвращает.

