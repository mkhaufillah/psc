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
    static let encodeFailedTag = "Gagal encode"
    static let decodeFailedTag = "Gagal decode"
    static let didNotReceiveData = "Gagal menerima data"
    static let HTTPError = "Gagal melakukan request ke server"
    static let JSONError = "Gagal melakukan konversi ke JSON"
    static let InvalidToken = "Sesi anda telah berakhir"
    // SignIn
    static let emailPasswordUnmatch = "\"Email\" atau \"Kata Sandi\" anda salah"
    static let requiredEmail = "\"Email\" belum terisi"
    static let requiredPassword = "\"Kata Sandi\" belum terisi"
    static let invalidEmailFormat = "Format email tidak tepat"
    static let failDeleteLocalUserData = "Terdapat kesalahan sistem (Gagal menghapus lokal data)"
    static let failAddLocalUserData = "Terdapat kesalahan sistem (Gagal menambah lokal data)"
    // Register
    static let requiredName = "\"Nama\" belum terisi"
    static let requiredReference = "\"Referensi\" belum terisi"
    static let requiredDetailReference = "\"Detail Referensi\" belum terisi"
    static let requiredPicture = "\"Foto\" masih kosong"
    static let passwordUnmatch = "\"Kata Sandi\" tidak sama"
    
    /// App store policy
    // static let requiredGender = "\"Jenis Kelamin\" belum terisi"
    // static let requiredPhone = "\"No. Telepon\" belum terisi"
    // static let requiredBirthdate = "\"Tanggal Lahir\" tidak masuk akal"
    // static let requiredAddress = "\"Alamat\" belum terisi"
    // static let requiredEducation = "\"Pendidikan\" belum terisi"
    
    static let requiredRefCode = "\"Kode Referensi\" belum terisi"
    
    // Whatsapp
    static let whatsappCannotOpened = "\"Whatsapp\" tidak bisa dibuka"
    // Video
    static let audioSystemError = "\"Audio\" sistem anda bermasalah"
    // Data
    static let notFoundData = "\"Data\" tidak ditemukan"
    static let failedToLoadData = "\"Data\" gagal dimuat"
    static let retry = "ulangi"
    /// App store policy
    // In app purchase
    static let cannotLoadProducts = "Tidak bisa memuat produk pembelian"
    static let invalidProductsFound = "Produk pembelian tidak valid"
}
