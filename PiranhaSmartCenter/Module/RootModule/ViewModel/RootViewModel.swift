//
//  RootViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 14/07/21.
//

import Foundation
import RealmSwift
import Network

enum PageTab {
    case Home
    case Course
    case Exam
    case Profile
}

enum DataStatus {
    case Init
    case InLocal
    case InProgressToNetwork
    case InNetwork
    case NotInLocal
}

class RootViewModel: ObservableObject {
    @Published var dataStatusUser: DataStatus = .Init
    @Published var dataStatusRecapCourses: DataStatus = .Init
    @Published var dataStatusCourses: DataStatus = .Init
    @Published var dataStatusMaterials = [DataStatus]()
    @Published var dataStatusMaterialsPerPage = [DataStatus]()
    @Published var dataStatusPublications: DataStatus = .Init
    @Published var dataStatusActivities: DataStatus = .Init
    @Published var dataStatusAds: DataStatus = .Init
    
    @Published var dataUser: UserModel? = nil
    @Published var dataRecapCourses = Array<RecapCourseModel>()
    @Published var dataCourses = Array<CourseModel>()
    @Published var dataMaterials = [Array<MaterialModel>]()
    @Published var dataPublications = Array<PublicationModel>()
    @Published var dataActivities = Array<ActivityModel>()
    @Published var dataAds = Array<AdsModel>()
    
    @Published var currentTab: PageTab = .Home
    @Published var isShowPopupMenu = false
    @Published var becomeMemberPageIsActive = false
    
    @Published var selectedCourseIdx = 0
    @Published var materialKeyword = ""
    @Published var coursePage = [Int]()
    @Published var isFinalPage = [Bool]()
    
    @Published var statusConnection = 1
    
    @Published var isFirstTime = false
    @Published var indexOnboard = 0
    
    @Published var isOpenAds: Bool = true
    
    @Published var homeRefresh: Bool = false {
        didSet {
            if oldValue == false && homeRefresh == true {
                initDataUserFromNetwork()
                initDataRecapCoursesFromNetwork()
                initDataActivitiesFromNetwork()
                initDataPublicationsFromNetwork()
                initDataAdsFromNetwork()
            }
        }
    }
    @Published var courseRefresh: Bool = false {
        didSet {
            if oldValue == false && courseRefresh == true {
                initDataCoursesFromNetwork()
            }
        }
    }
    @Published var profileRefresh: Bool = false {
        didSet {
            if oldValue == false && courseRefresh == true {
                initDataUserFromNetwork()
            }
        }
    }
    
    let profileProvider = ProfileProvider()
    let recapCourseProvider = RecapCourseProvider()
    let courseProvider = CourseProvider()
    let publicationProvider = PublicationProvider(page: 1)
    let activityProvider = ActivityProvider(page: 1)
    let adsProvider = AdsProvider()
    
    init() {
        // Network
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.statusConnection = 0
                }
            } else {
                DispatchQueue.main.async {
                    self.statusConnection = 1
                }
            }
        }
        monitor.start(queue: .global())
        
        // Get in local user
        do {
            let realm = try Realm()
            let data = realm.objects(SignInDataModel.self)
            dataUser = data.first?.user
            
            isFirstTime = realm.objects(OnBoardModel.self).first?.isFirstTime ?? true
            
            if dataUser == nil {
                dataStatusUser = .NotInLocal
            }
            
            dataStatusUser = .InLocal
        } catch {
            if GlobalStaticData.isDebug {
                print("[Realm error] Error when read user data")
            }
            dataStatusUser = .NotInLocal
        }
    }
    
    func finishOnBoard() {
        do {
            // Save into local data with realm
            try self.saveOnboardData()
        } catch {
            do {
                try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
                
                try self.saveOnboardData()
            } catch {
                if GlobalStaticData.isDebug {
                    print("[Realm error] Error when write onboard data")
                }
            }
        }
    }
    
    func saveOnboardData() throws {
        // Save into local data with realm
        let realm = try Realm()
        try realm.write {
            // Delete data first
            realm.deleteAll()
            realm.add(OnBoardModel())
        }
        isFirstTime = false
    }
    
    func resetAllData() {
        dataStatusUser = .Init
        dataStatusRecapCourses = .Init
        dataStatusCourses = .Init
        dataStatusPublications = .Init
        dataStatusActivities = .Init
        dataStatusAds = .Init
        dataUser = nil
        dataRecapCourses = []
        dataCourses = []
        dataPublications = []
        dataActivities = []
        dataAds = []
    }
    
    func initDataUserFromNetwork() {
        // Get user from network
        profileProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: error?.desc ?? "")
                    self.dataStatusUser = .InLocal
                    if error?.desc == ErrorString.InvalidToken || (error?.desc ?? "").contains(ErrorString.decodeFailedTag) {
                        do {
                            // Delete data from realm
                            let realm = try Realm()
                            try realm.write {
                                realm.deleteAll()
                            }
                        } catch {
                            if GlobalStaticData.isDebug {
                                print("[Realm error] Error when delete user data")
                            }
                        }
                        self.resetAllData()
                    }
                }
                if result != nil {
                    self.dataUser = result?.data?.data.first
                    self.dataStatusUser = .InNetwork
                    
                    // Update in local user
                    do {
                        let realm = try Realm()
                        
                        let data = realm.objects(SignInDataModel.self)
                        
                        if let firstData = data.first {
                            try realm.write {
                                firstData.user?.name = self.dataUser?.name
                                firstData.user?.email = self.dataUser?.email
                                firstData.user?.emailVerifiedAt = self.dataUser?.emailVerifiedAt
                                firstData.user?.noHp = self.dataUser?.noHp
                                firstData.user?.address = self.dataUser?.address
                                firstData.user?.gender = self.dataUser?.gender
                                firstData.user?.picture = self.dataUser?.picture
                                firstData.user?.birthdate = self.dataUser?.birthdate
                                firstData.user?.statusAccount = self.dataUser?.statusAccount
                                firstData.user?.role = self.dataUser?.role
                                firstData.user?.createdAt = self.dataUser?.createdAt
                                firstData.user?.updatedAt = self.dataUser?.updatedAt
                                firstData.user?.deletedAt = self.dataUser?.deletedAt
                                firstData.user?.referenceId = self.dataUser?.referenceId
                                firstData.user?.education = self.dataUser?.education
                                firstData.user?.detailReferenceEtc = self.dataUser?.detailReferenceEtc
                            }
                        }
                    } catch {
                        NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.failAddLocalUserData)
                    }
                }
                self.homeRefresh = false
                self.profileRefresh = false
            }
        })
    }
    
    func initDataRecapCoursesFromNetwork() {
        // Get publications from network
        recapCourseProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getRecapCoursesData, subtitle: error?.desc ?? "")
                    self.dataStatusRecapCourses = .NotInLocal
                }
                
                if result != nil {
                    self.dataRecapCourses = RealmListHelper<RecapCourseModel>().listToArray(list: result?.data ?? List<RecapCourseModel>())
                    if self.dataStatusMaterials.count <= 0 {
                        self.dataStatusMaterials = [DataStatus](repeating: .Init, count: self.dataRecapCourses.count)
                    }
                    if self.dataStatusMaterialsPerPage.count <= 0 {
                        self.dataStatusMaterialsPerPage = [DataStatus](repeating: .Init, count: self.dataRecapCourses.count)
                    }
                    if self.dataMaterials.count <= 0 {
                        self.dataMaterials = [Array<MaterialModel>](repeating: [MaterialModel](), count: self.dataRecapCourses.count)
                    }
                    if self.coursePage.count <= 0 {
                        self.coursePage = [Int](repeating: 1, count: self.dataRecapCourses.count)
                    }
                    if self.isFinalPage.count <= 0 {
                        self.isFinalPage = [Bool](repeating: false, count: self.dataRecapCourses.count)
                    }
                    
                    self.dataStatusRecapCourses = .InNetwork
                }
                self.homeRefresh = false
            }
        })
    }
    
    func initDataCoursesFromNetwork() {
        courseProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getCoursesData, subtitle: error?.desc ?? "")
                    self.dataStatusCourses = .NotInLocal
                }
                if result != nil {
                    self.dataCourses = RealmListHelper<CourseModel>().listToArray(list: result?.data?.data ?? List<CourseModel>())
                    self.dataStatusMaterials = [DataStatus](repeating: .Init, count: self.dataCourses.count)
                    self.dataStatusMaterialsPerPage = [DataStatus](repeating: .Init, count: self.dataCourses.count)
                    self.dataMaterials = [Array<MaterialModel>](repeating: [MaterialModel](), count: self.dataCourses.count)
                    self.coursePage = [Int](repeating: 1, count: self.dataCourses.count)
                    self.isFinalPage = [Bool](repeating: false, count: self.dataCourses.count)
                    
                    // Get material in first course
                    if self.dataCourses.count > 0 {
                        self.initDataMaterialsFromNetwork(index: 0)
                    }
                    
                    self.dataStatusCourses = .InNetwork
                    self.selectedCourseIdx = 0
                }
                self.courseRefresh = false
            }
        })
    }
    
    func initDataMaterialsFromNetwork(index: Int, isNextPage: Bool = false, isSearch: Bool = false) {
        if !isNextPage {
            self.coursePage[index] = 1
            self.dataStatusMaterials[index] = .InProgressToNetwork
        } else {
            self.dataStatusMaterialsPerPage[index] = .InProgressToNetwork
        }
        
        if isSearch {
            for (i, _) in self.dataStatusMaterials.enumerated() {
                if i != index {
                    self.dataStatusMaterials[i] = .Init
                }
            }
        }
        
        let searchMaterialProvider = SearchMaterialProvider(indexLocalData: index, keyword: materialKeyword, courseId: "\(dataCourses[index].id)", page: coursePage[index])
        // Send to server
        searchMaterialProvider.doAction(response: { result, error, i in
            // Set result to local data
            DispatchQueue.main.async {
                if error != nil {
                    if isSearch && ((error?.desc ?? "").contains(ErrorString.decodeFailedTag)) {
                        self.dataMaterials[i] = []
                        self.dataStatusMaterials[i] = .InNetwork
                    } else if isNextPage && ((error?.desc ?? "").contains(ErrorString.decodeFailedTag)) {
                        self.dataStatusMaterialsPerPage[i] = .InNetwork
                        self.isFinalPage[i] = true
                    } else {
                        if self.materialKeyword != "" && ((error?.desc ?? "").contains(ErrorString.decodeFailedTag)) {
                            self.dataMaterials[i] = []
                            self.dataStatusMaterials[i] = .InNetwork
                        } else {
                            NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getMaterialData, subtitle: error?.desc ?? "")
                            self.dataStatusMaterials[i] = .NotInLocal
                        }
                    }
                }
                if result != nil {
                    if isNextPage {
                        let temp = RealmListHelper<MaterialModel>().listToArray(list: result?.data?.data ?? List<MaterialModel>())
                        
                        self.dataMaterials[i] = self.dataMaterials[i] + temp
                        
                        self.dataStatusMaterialsPerPage[i] = .InNetwork
                        self.coursePage[i] += 1
                        self.isFinalPage[i] = false
                    } else {
                        self.dataMaterials[i] = RealmListHelper<MaterialModel>().listToArray(list: result?.data?.data ?? List<MaterialModel>())
                        
                        self.dataStatusMaterials[i] = .InNetwork
                        self.coursePage[i] = 2
                        self.isFinalPage[i] = false
                    }
                }
            }
        })
    }
    
    func initDataPublicationsFromNetwork() {
        // Get publications from network
        publicationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getPublicationsData, subtitle: error?.desc ?? "")
                    self.dataStatusPublications = .NotInLocal
                }
                
                if result != nil {
                    self.dataPublications = RealmListHelper<PublicationModel>().listToArray(list: result?.data?.data ?? List<PublicationModel>())
                    self.dataStatusPublications = .InNetwork
                }
                self.homeRefresh = false
            }
        })
    }
    
    func initDataActivitiesFromNetwork() {
        // Get activities from network
        activityProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getAcyivitiesData, subtitle: error?.desc ?? "")
                    self.dataStatusActivities = .NotInLocal
                }
                
                if result != nil {
                    self.dataActivities = RealmListHelper<ActivityModel>().listToArray(list: result?.data?.data ?? List<ActivityModel>())
                    self.dataStatusActivities = .InNetwork
                }
                self.homeRefresh = false
            }
        })
    }
    
    func initDataAdsFromNetwork() {
        // Get publications from network
        adsProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getPublicationsData, subtitle: error?.desc ?? "")
                    self.dataStatusAds = .NotInLocal
                }
                
                if result != nil {
                    self.dataAds = RealmListHelper<AdsModel>().listToArray(list: result?.data?.data ?? List<AdsModel>())
                    self.dataStatusAds = .InNetwork
                }
                self.homeRefresh = false
            }
        })
    }
    
    func openWhatsapp() {
        if (WhatsappHelper.doOpen(number: RootString.phoneNumberPSC, text: RootString.chatText) != nil) {
            NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.whatsappCannotOpened)
        }
    }
}
