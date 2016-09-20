//
//  JSON.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import Foundation

struct CuriosityRoverData: JSONObjectConvertable, CustomStringConvertible {
    class PhotoInfo: JSONObjectConvertable, CustomStringConvertible {
        var id: Int64?
        var sol: Int64?
        var camera: CameraInfo?
        var img_src: URL?
        var earth_date: Date?
        var rover: RoverInfo?

        required init?(JSON: JSONType?) {
            guard let JSON = JSON else { return nil }
            guard case .dictionary(let dictionary) = JSON else { return nil }

            id = dictionary.jsonValue("id")
            sol = dictionary.jsonValue("sol")
            camera = dictionary.jsonValue("camera")
            img_src = dictionary.jsonValue("img_src")
            earth_date = dictionary.jsonValue("earth_date")
            rover = dictionary.jsonValue("rover")
        }

        var description: String {
            return "====\nPhotoInfo\n\tid:\(id)\n\tsol:\(sol)\n\tcamera:\(camera)\n\timg_src:\(img_src)\n\tearth_date:\(earth_date)\n\trover:\(rover)\n====\n"
        }
    }

    struct CameraInfo: JSONObjectConvertable, CustomStringConvertible {
        var id: Int64?
        var name: String?
        var rover_id: Int64?
        var full_name: String?

        init?(JSON: JSONType?) {
            guard let JSON = JSON else { return nil }
            guard case .dictionary(let dictionary) = JSON else { return nil }

            id = dictionary.jsonValue("id")
            name = dictionary.jsonValue("name")
            rover_id = dictionary.jsonValue("rover_id")
            full_name = dictionary.jsonValue("full_name")
        }

        var description: String {
            return "====\nCameraInfo\n\tid:\(id)\n\tname:\(name)\n\trover_id:\(rover_id)\n\tfull_name:\(full_name)\n====\n"
        }
    }

    struct CameraSummaryInfo: JSONObjectConvertable, CustomStringConvertible {
        var name: String?
        var full_name: String?

        init?(JSON: JSONType?) {
            guard let JSON = JSON else { return nil }
            guard case .dictionary(let dictionary) = JSON else { return nil }

            name = dictionary.jsonValue("name")
            full_name = dictionary.jsonValue("full_name")
        }

        var description: String {
            return "====\nCameraSummaryInfo\n\tname:\(name)\n\tfull_name:\(full_name)\n====\n"
        }
    }

    struct RoverInfo: JSONObjectConvertable, CustomStringConvertible {
        var id: Int64?
        var name: String?
        var landing_date: Date?
        var max_sol: Int64?
        var max_date: Date?
        var total_photos: Int64?
        var cameras = [CameraSummaryInfo]()

        init?(JSON: JSONType?) {
            guard let JSON = JSON else { return nil }
            guard case .dictionary(let dictionary) = JSON else { return nil }

            self.id = dictionary.jsonValue("id")
            name = dictionary.jsonValue("name")
            landing_date = dictionary.jsonValue("landing_date")
            max_sol = dictionary.jsonValue("max_sol")
            max_date = dictionary.jsonValue("max_date")
            total_photos = dictionary.jsonValue("total_photos", defaultValue: 1)
            cameras = dictionary.jsonValue("cameras")
        }

        var description: String {
            return "====\nRoverInfo\n\tid:\(id)\n\tname\(name)\n\tlanding_date:\(landing_date)\n]\tmax_sol:\(max_sol)\n\tmax_date:\(max_date)\n\ttotal_photos:\(total_photos)\n\tcameras:\(cameras)\n====\n"
        }
    }

    var photos = [PhotoInfo]()

    init?(JSON: JSONType?) {
        guard let JSON = JSON else { return nil }
        guard case .dictionary(let dictionary) = JSON else { return nil }

        photos = dictionary.jsonValue("photos")
    }

    var description: String {
        return "====\nRoverInfo\n\tphotos:\(photos)\n====\n"
    }
}
