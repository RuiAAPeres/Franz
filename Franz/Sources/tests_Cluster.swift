import XCTest
import ReactiveSwift
@testable import Franz

class ClusterTests: XCTestCase {

    func test_consumer() {

        let cluster = Cluster<String, String>()
        let scheduler = TestScheduler()
        let consumer = cluster.makeConsumer(for: "Topic1", on: scheduler)
        var counter = 0

        consumer.observeValues { value in
            XCTAssert(value == ["Hello1"])
            counter += 1
        }

        cluster.send(message: "Hello1", forTopic: "Topic1")
        scheduler.advance(by: .seconds(1))
        XCTAssert(counter == 1)
    }

    func test_topic_filter() {

        let cluster = Cluster<String, String>()
        let scheduler = TestScheduler()
        let consumer = cluster.makeConsumer(for: "Topic1")
        var counter = 0

        consumer.observeValues { value in
            counter += 1
        }

        cluster.send(message: "Hello1", forTopic: "Topic2")
        scheduler.advance(by: .seconds(1))
        XCTAssert(counter == 0)
    }

    func test_collection() {

        let cluster = Cluster<String, String>()
        let scheduler = TestScheduler()
        let consumer = cluster.makeConsumer(for: "Topic1", on: scheduler)
        var counter = 0

        consumer.observeValues { value in
            counter += 1
            XCTAssert(value == ["Hello1", "Hello2"])
        }

        cluster.send(message: "Hello1", forTopic: "Topic1")
        cluster.send(message: "Hello2", forTopic: "Topic1")

        scheduler.advance(by: .seconds(1))
        XCTAssert(counter == 1)
    }
}

