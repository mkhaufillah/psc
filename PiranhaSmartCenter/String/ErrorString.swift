//
//  ErrorString.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 10/07/21.
//

struct ErrorString : StringProtocol {
    static let title = "Terdapat error sistem"
    static let shortTitle = "Error"
    // Network
    static let noDataConnection = "Tidak ada koneksi internet, silahkan hidupkan wifi atau data selular"
    static let urlInvalid = "URL bermasalah"
    static let encodeFailed = "Gagal melakukan encode data"
    static let decodeFailed = "Gagal melakukan decode data"
    static let didNotReceiveData = "Gagal menerima data"
    static let HTTPError = "Gagal melakukan request ke server"
    static let JSONError = "Gagal melakukan konversi ke JSON"
    // SignIn
    static let emailPasswordUnmatch = "\"Email\" atau \"Kata Sandi\" anda salah"
    static let requiredEmail = "\"Email\" belum terisi"
    static let requiredPassword = "\"Kata Sandi\" belum terisi"
    static let invalidEmailFormat = "Format email tidak tepat"
    static let failDeleteLocalUserData = "Gagal menghapus data pengguna"
    static let failAddLocalUserData = "Gagal menambah data pengguna"
    // Register
    static let requiredName = "\"Nama\" belum terisi"
    static let requiredGender = "\"Jenis Kelamin\" belum terisi"
    static let requiredPhone = "\"No. Telepon\" belum terisi"
    static let requiredBirthdate = "\"Tanggal Lahir\" tidak masuk akal"
    static let requiredAddress = "\"Alamat\" belum terisi"
    static let requiredReference = "\"Referensi\" belum terisi"
    static let requiredDetailReference = "\"Detail Referensi\" belum terisi"
    static let requiredEducation = "\"Pendidikan\" belum terisi"
    static let requiredPicture = "\"Foto\" masih kosong"
    static let passwordUnmatch = "\"Kata Sandi\" tidak sama"
    // Whatsapp
    static let whatsappCannotOpened = "\"Whatsapp\" tidak bisa dibuka"
}
