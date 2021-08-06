//
//  ExerciseViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation
import RealmSwift

class ExerciseViewModel: ObservableObject {
    @Published var questionPageIsActive = false
    @Published var onboardingPageIsActive: Int? = nil
    
    @Published var dataStatusMaterials = [DataStatus]()
    @Published var dataStatusMaterialsPerPage = [DataStatus]()
    @Published var dataStatusCourses: DataStatus = .Init
    @Published var dataStatusHistories: DataStatus = .Init
    @Published var dataStatusHistoriesPerPage: DataStatus = .Init
    
    @Published var dataCourses = Array<CourseModel>()
    @Published var dataMaterials = [Array<MaterialModel>]()
    @Published var dataHistories = [GetResultExerciseModel]()
    
    @Published var selectedCourseIdx = 0
    @Published var materialKeyword = ""
    @Published var coursePage = [Int]()
    @Published var isFinalPage = [Bool]()
    
    @Published var historyPage = 1
    @Published var isHistoryFinalPage = false
    
    let courseProvider = CourseProvider()
    
    func initDataCoursesFromNetwork() {
        materialKeyword = ""
        selectedCourseIdx = 0
        // Get courses from network
        self.dataStatusCourses = .InProgressToNetwork
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
                    if isSearch && ((error?.desc ?? "") == ErrorString.decodeFailed) {
                        self.dataMaterials[i] = []
                        self.dataStatusMaterials[i] = .InNetwork
                    } else if isNextPage && ((error?.desc ?? "") == ErrorString.decodeFailed) {
                        self.dataStatusMaterialsPerPage[i] = .InNetwork
                        self.isFinalPage[i] = true
                    } else {
                        if self.materialKeyword != "" && ((error?.desc ?? "") == ErrorString.decodeFailed) {
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
    
    func initDataHistoriesFromNetwork(isNextPage: Bool = false) {
        // Get histories from network
        if !isNextPage {
            self.historyPage = 1
            self.dataStatusHistories = .InProgressToNetwork
        } else {
            self.dataStatusHistoriesPerPage = .InProgressToNetwork
        }
        
        let getResultExerciseProvider = GetResultExerciseProvider(page: historyPage)
        
        getResultExerciseProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if isNextPage && ((error?.desc ?? "") == ErrorString.decodeFailed) {
                        self.dataStatusHistoriesPerPage = .InNetwork
                        self.isHistoryFinalPage = true
                    } else {
                        if (error?.desc ?? "") != ErrorString.decodeFailed {
                            NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                        } else {
                            NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ErrorString.notFoundData)
                        }
                        self.dataStatusHistories = .NotInLocal
                    }
                }
                if result != nil {
                    if isNextPage {
                        let temp = RealmListHelper<GetResultExerciseModel>().listToArray(list: result?.data?.data ?? List<GetResultExerciseModel>())
                        
                        self.dataHistories = self.dataHistories + temp
                        
                        self.dataStatusHistoriesPerPage = .InNetwork
                        self.historyPage += 1
                        self.isHistoryFinalPage = false
                    } else {
                        self.dataHistories = RealmListHelper<GetResultExerciseModel>().listToArray(list: result?.data?.data ?? List<GetResultExerciseModel>())
                        
                        self.dataStatusHistories = .InNetwork
                        self.historyPage = 2
                        self.isHistoryFinalPage = false
                    }
                }
            }
        })
    }
}
