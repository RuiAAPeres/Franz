import XCTest
import ReactiveSwift
@testable import Franz

class ClusterTests: XCTestCase {

    func test_consumer() {

        let cluster = Cluster<String, String>()
        let consumer = cluster.makeConsumer(for: "Topic1")

        consumer.observeValues { value in
            XCTAssert(value == "Hello1")
        }

        cluster.send(message: "Hello1", forTopic: "Topic1")
    }

    func test_topic_filter() {

        let cluster = Cluster<String, String>()
        let consumer = cluster.makeConsumer(for: "Topic1")

        var counter = 0

        consumer.observeValues { value in
            counter = 1
        }

        cluster.send(message: "Hello1", forTopic: "Topic2")
        XCTAssert(counter == 0)
    }
}

