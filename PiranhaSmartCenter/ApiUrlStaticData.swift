//
//  ApiUrlStaticData.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

private struct BaseApiUrlStatic {
    static let base1 = "/api"
}

private struct VersionApiUrlStatic {
    static let version1 = "/v1"
}

struct ApiUrlStatic {
    static let signIn = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/login"
    static let register = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/register"
    static let profile = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/info"
    static let course = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/course/brevet"
    static let recapCourse = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/rekapitulasi_course"
    static let searchMaterial = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/course/materi/search"
    static let publication = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/publication"
    static let activity = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/activity"
}
