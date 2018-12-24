import ReactiveSwift
import enum Result.NoError

final class Cluster<Message, Topic: Equatable> {

    private typealias Tagged = (Message, Topic)

    private let cache: Signal<Tagged, NoError>
    private let cacheObserver: Signal<Tagged, NoError>.Observer

    public init() {
        let (signal, observer) = Signal<Tagged, NoError>.pipe()
        self.cacheObserver = observer
        self.cache = signal
    }

    public func send(message: Message, forTopic topic: Topic) {
        cacheObserver.send(value: (message, topic))
    }

    public func makeConsumer(
        for topic: Topic,
        with interval: DispatchTimeInterval = .seconds(1),
        on scheduler: DateScheduler = QueueScheduler()
        ) -> Signal<[Message], NoError> {

        let byTopic: (Tagged) -> Bool = second >>> (topic |> curry(==))

        return cache
            .filter(byTopic)
            .collect(every: interval, on: scheduler, discardWhenCompleted: false)
            .map(first |> map)
    }
}
