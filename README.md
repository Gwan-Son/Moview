# Moview
Firebase를 통한 구글 및 애플 로그인

Firestore를 이용한 사용자 데이터 관리

TMDB API와 Alamofire, KingFisher를 사용한 영화 리스트 제공

## 목차
- [🚀 개발 기간](#-개발-기간)
- [💻 개발 환경](#-개발-환경)
- [👀 미리 보기](#-미리보기)
- [🔥 Firestore 실시간 데이터베이스](#-firestore-실시간-데이터베이스)
- [🍿 TMDB API와 Alamofire](#-tmdb-api와-alamofire)
- [📐 MVVM 패턴 채택](#-mvvm-패턴-채택)
- [📁 파일 구조](#-파일-구조)

---

# 🚀 개발 기간
24.09.14 ~ 24.10.18 (약 1개월)

# 💻 개발 환경
- `XCode 16.0`
- `Swift 6.0.0`

<p align="center" width="100%">
 <img src="https://github.com/user-attachments/assets/160d0c1c-d329-4864-8c99-ba12c5553a3b" width="30%">
 <img src="https://github.com/user-attachments/assets/387db85d-2129-4873-8161-e69ea121d55c" width="30%">
 <img src="https://github.com/user-attachments/assets/84dbbcfc-bb64-4b4c-8d86-8a3761a4baba" width="30%">
 <br>
 <img src="https://github.com/user-attachments/assets/18c54b93-b782-4066-8427-c470309fd744" width="30%">
 <img src="https://github.com/user-attachments/assets/cdf37cda-5f90-4b35-adbd-361b32c1922f" width="30%">
</p>

# 👀 미리보기
![Simulator Screen Recording - iPhone 16 Pro - 2024-10-18 at 23 32 33](https://github.com/user-attachments/assets/eb5a2bf7-4a64-492c-bb02-87a18b508b1d)



# 🔥 Firestore 실시간 데이터베이스
firebase로 로그인을 성공하게 되면 firestore에 "users" 컬렉션에 사용자의 UID값을 가지는 document를 생성합니다.

```
    // firestore 저장소 생성 코드
    func createUserData(_ userInfo: UserAuthInfo) {
        let displayName = if userInfo.lastName == nil && userInfo.firstName == nil { "이름없음" } else {
            String(userInfo.lastName ?? "") + String(userInfo.firstName ?? "")
        }
        let data: [String: Any] = [
            "uid": userInfo.uid,
            "email": userInfo.email ?? "",
            "firstName": userInfo.firstName ?? "",
            "lastName": userInfo.lastName ?? "",
            "displayName": displayName,
            "movies": []
        ]
        db.collection("users").document(userInfo.uid).setData(data)
    }
```

사용자가 DetailView(영화 상세 뷰)에서 즐겨찾기 버튼을 누르게 되면 현재 사용자의 즐겨찾기 데이터에 포함되어 있는지를 비교하고, 존재하지 않으면 즐겨찾기 추가를 진행합니다. 반대로 존재하면 즐겨찾기 목록에서 제거합니다.

```
    // 즐겨찾기 추가 및 제거 코드
    func updateFavorite(_ uid: String, id: Int, title: String, poster_path: String, vote_average: Double) {
        let movie: [String: Any] = [
            "title": title,
            "poster_path": poster_path,
            "vote_average": vote_average
        ]
        let data = db.collection("users").document(uid).collection("favorites").document(String(id))
        
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                data.delete()
            } else {
                data.setData(movie)
            }
        }
        updateUserMovie(uid, updateMovie: id)
    }
```

# 🍿 TMDB API와 Alamofire
MovieService.swift를 생성하여 Alamofire로 각각의 해당하는 api를 불러오는 메서드를 생성하였습니다.

해당 주소마다 필요한 파라미터들을 추가하고, 불러온 JSON 파일을 MovieModel로 변환했습니다.

```
    // Alamofire를 이용하여 TMDB에서 JSON을 불러오는 코드
    func fetchMovie(from endpoint: String, with additionalParams: [String: String] = [:], completion: @escaping (MovieResponse?) -> Void) {
        let baseURL = "https://api.themoviedb.org/3"
        let url = baseURL + endpoint
        
        var params: [String: String] = [
            "api_key": apiKey,
            "language": "ko-KR",
            "page": "1",
            "region": "KR"
        ]
        
        params.merge(additionalParams) { (_, new) in new }
        
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
```

```
    // 해당 카테고리별 필요한 파라미터를 추가한 코드
    func getMovie(completion: @escaping (MovieResponse?) -> Void) {
        let additionalParams = [
            "include_adult": "false",
            "include_video": "false",
            "sort_by": "popularity.desc"
        ]
        
        fetchMovie(from: "/discover/movie", with: additionalParams, completion: completion)
    }
    
    func getMovieDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        fetchMovieDetail(from: String(id), completion: completion)
    }
    
    func getGenreMovie(with page: Int, for genre: String, completion: @escaping (MovieResponse?) -> Void) {
        var additionalParams = [
            "include_adult": "false",
            "include_video": "false",
            "with_genres": genre
        ]
        
        if page != 0 {
            additionalParams["page"] = String(page)
        }
        
        fetchMovie(from: "/discover/movie", with: additionalParams, completion: completion)
    }
    
    func getPopularMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "/movie/popular", completion: completion)
    }
    
    func getPopularMovie(page: Int, completion: @escaping (MovieResponse?) -> Void) {
        let additionalParams = [
            "page": String(page)
        ]
        fetchMovie(from: "/movie/popular",with: additionalParams, completion: completion)
    }
    
    func getNowPlayingMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "/movie/now_playing", completion: completion)
    }
    
    func getNowPlayingMovie(page: Int, completion: @escaping (MovieResponse?) -> Void) {
        let additionalParams = [
            "page": String(page)
        ]
        fetchMovie(from: "/movie/now_playing",with: additionalParams, completion: completion)
    }
    
    func getTopRatedMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "movie/top_rated", completion: completion)
    }
```


# 📐 MVVM 패턴 채택
JSON을 MovieModel로 변환시켜 각각의 ViewModel에서 사용할 수 있게 하였습니다.

```
// MovieModel
struct MovieModel: Hashable, Identifiable {
    var backdrop_path: String
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var vote_average: Double
    var vote_count: Int
}
```

```
// MovieViewModel.swift
class MovieViewModel: ObservableObject {
    @Published var popularMovies = [MovieModel]()
    @Published var nowPlayingMovies = [MovieModel]()
    ...
```


# 📁 파일 구조
```
.
├── Moview
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   ├── GoogleIcon.imageset
│   │   │   ├── Contents.json
│   │   │   └── GoogleIcon.png
│   │   └── GoogleRed.colorset
│   │       └── Contents.json
│   ├── Components
│   │   ├── CircularProgressView.swift
│   │   ├── MoreButton.swift
│   │   ├── MoviePosterView.swift
│   │   └── SignComponents
│   │       ├── AppAlert.swift
│   │       ├── SignInWithAppleButtonView.swift
│   │       ├── SignInWithGoogleButtonView.swift
│   │       └── SignInWithGuestButtonView.swift
│   ├── DetailView
│   │   ├── DetailGenreView.swift
│   │   ├── DetailView.swift
│   │   └── DetailViewModel.swift
│   ├── Extension
│   │   ├── ASAuthorizationAppleIDButton+Extension.swift
│   │   ├── Color+Extenstion.swift
│   │   └── UIApplication+Extension.swift
│   ├── FavoriteView
│   │   ├── FavoriteView.swift
│   │   └── FavoriteViewModel.swift
│   ├── GenreView
│   │   ├── GenreView.swift
│   │   └── GenreViewModel.swift
│   ├── GoogleService-Info.plist
│   ├── HomeView
│   │   ├── HomeView.swift
│   │   └── HomeViewModel.swift
│   ├── Info.plist
│   ├── LoginView
│   │   ├── LoginView.swift
│   │   └── LogoView.swift
│   ├── Model
│   │   ├── Genres.swift
│   │   ├── MovieCategory.swift
│   │   ├── MovieDetailModel.swift
│   │   ├── MovieDetailResponse.swift
│   │   ├── MovieModel.swift
│   │   ├── MovieResponse.swift
│   │   └── Tab.swift
│   ├── MovieView
│   │   ├── CardView.swift
│   │   ├── DividerCategoryView.swift
│   │   ├── GenreCardView.swift
│   │   ├── MovieSlideView.swift
│   │   ├── MovieView.swift
│   │   ├── MovieViewModel.swift
│   │   └── SeeAllView
│   │       ├── SeeAllView.swift
│   │       └── SeeAllViewModel.swift
│   ├── Moview.entitlements
│   ├── MoviewApp.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── Secrets.xcconfig
│   ├── Service
│   │   ├── Auth
│   │   │   ├── AuthManager.swift
│   │   │   ├── AuthManagerEnvironmentKey.swift
│   │   │   ├── AuthProvider.swift
│   │   │   ├── FirebaseAuthProvider.swift
│   │   │   ├── Helper
│   │   │   │   ├── SignInWithApple.swift
│   │   │   │   └── SignInWithGoogle.swift
│   │   │   └── MockAuthProvider.swift
│   │   ├── FirestoreManager.swift
│   │   ├── IsLoggedInEnvironmentKey.swift
│   │   └── MovieService.swift
│   └── SettingView
│       ├── ProfileView.swift
│       ├── SettingView.swift
│       └── SettingViewModel.swift
├── Moview.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── swiftpm
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       └── simgwanhyeok.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   ├── xcshareddata
│   │   └── xcschemes
│   │       └── Moview.xcscheme
│   └── xcuserdata
│       └── simgwanhyeok.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── Moview.xcworkspace
│   ├── contents.xcworkspacedata
│   ├── xcshareddata
│   │   ├── IDEWorkspaceChecks.plist
│   │   └── swiftpm
│   │       ├── Package.resolved
│   │       └── configuration
│   └── xcuserdata
│       └── simgwanhyeok.xcuserdatad
│           ├── UserInterfaceState.xcuserstate
│           ├── xcdebugger
│           │   └── Breakpoints_v2.xcbkptlist
│           └── xcschemes
│               └── xcschememanagement.plist
├── Podfile
├── Podfile.lock
├── Pods
│   ├── Alamofire
│   │   ├── LICENSE
│   │   ├── README.md
│   │   └── Source
│   │       ├── Alamofire.swift
│   │       ├── Core
│   │       │   ├── AFError.swift
│   │       │   ├── DataRequest.swift
│   │       │   ├── DataStreamRequest.swift
│   │       │   ├── DownloadRequest.swift
│   │       │   ├── HTTPHeaders.swift
│   │       │   ├── HTTPMethod.swift
│   │       │   ├── Notifications.swift
│   │       │   ├── ParameterEncoder.swift
│   │       │   ├── ParameterEncoding.swift
│   │       │   ├── Protected.swift
│   │       │   ├── Request.swift
│   │       │   ├── RequestTaskMap.swift
│   │       │   ├── Response.swift
│   │       │   ├── Session.swift
│   │       │   ├── SessionDelegate.swift
│   │       │   ├── URLConvertible+URLRequestConvertible.swift
│   │       │   ├── UploadRequest.swift
│   │       │   └── WebSocketRequest.swift
│   │       ├── Extensions
│   │       │   ├── DispatchQueue+Alamofire.swift
│   │       │   ├── OperationQueue+Alamofire.swift
│   │       │   ├── Result+Alamofire.swift
│   │       │   ├── StringEncoding+Alamofire.swift
│   │       │   ├── URLRequest+Alamofire.swift
│   │       │   └── URLSessionConfiguration+Alamofire.swift
│   │       ├── Features
│   │       │   ├── AlamofireExtended.swift
│   │       │   ├── AuthenticationInterceptor.swift
│   │       │   ├── CachedResponseHandler.swift
│   │       │   ├── Combine.swift
│   │       │   ├── Concurrency.swift
│   │       │   ├── EventMonitor.swift
│   │       │   ├── MultipartFormData.swift
│   │       │   ├── MultipartUpload.swift
│   │       │   ├── NetworkReachabilityManager.swift
│   │       │   ├── RedirectHandler.swift
│   │       │   ├── RequestCompression.swift
│   │       │   ├── RequestInterceptor.swift
│   │       │   ├── ResponseSerialization.swift
│   │       │   ├── RetryPolicy.swift
│   │       │   ├── ServerTrustEvaluation.swift
│   │       │   ├── URLEncodedFormEncoder.swift
│   │       │   └── Validation.swift
│   │       └── PrivacyInfo.xcprivacy
│   ├── Headers
│   ├── Kingfisher
│   │   ├── LICENSE
│   │   ├── README.md
│   │   └── Sources
│   │       ├── Cache
│   │       │   ├── CacheSerializer.swift
│   │       │   ├── DiskStorage.swift
│   │       │   ├── FormatIndicatedCacheSerializer.swift
│   │       │   ├── ImageCache.swift
│   │       │   ├── MemoryStorage.swift
│   │       │   └── Storage.swift
│   │       ├── Extensions
│   │       │   ├── CPListItem+Kingfisher.swift
│   │       │   ├── ImageView+Kingfisher.swift
│   │       │   ├── NSButton+Kingfisher.swift
│   │       │   ├── NSTextAttachment+Kingfisher.swift
│   │       │   ├── TVMonogramView+Kingfisher.swift
│   │       │   ├── UIButton+Kingfisher.swift
│   │       │   └── WKInterfaceImage+Kingfisher.swift
│   │       ├── General
│   │       │   ├── ImageSource
│   │       │   │   ├── AVAssetImageDataProvider.swift
│   │       │   │   ├── ImageDataProvider.swift
│   │       │   │   ├── PHPickerResultImageDataProvider.swift
│   │       │   │   ├── Resource.swift
│   │       │   │   └── Source.swift
│   │       │   ├── KF.swift
│   │       │   ├── KFOptionsSetter.swift
│   │       │   ├── Kingfisher.swift
│   │       │   ├── KingfisherError.swift
│   │       │   ├── KingfisherManager.swift
│   │       │   └── KingfisherOptionsInfo.swift
│   │       ├── Image
│   │       │   ├── Filter.swift
│   │       │   ├── GIFAnimatedImage.swift
│   │       │   ├── GraphicsContext.swift
│   │       │   ├── Image.swift
│   │       │   ├── ImageDrawing.swift
│   │       │   ├── ImageFormat.swift
│   │       │   ├── ImageProcessor.swift
│   │       │   ├── ImageProgressive.swift
│   │       │   ├── ImageTransition.swift
│   │       │   └── Placeholder.swift
│   │       ├── Networking
│   │       │   ├── AuthenticationChallengeResponsable.swift
│   │       │   ├── ImageDataProcessor.swift
│   │       │   ├── ImageDownloader.swift
│   │       │   ├── ImageDownloaderDelegate.swift
│   │       │   ├── ImageModifier.swift
│   │       │   ├── ImagePrefetcher.swift
│   │       │   ├── RedirectHandler.swift
│   │       │   ├── RequestModifier.swift
│   │       │   ├── RetryStrategy.swift
│   │       │   ├── SessionDataTask.swift
│   │       │   └── SessionDelegate.swift
│   │       ├── PrivacyInfo.xcprivacy
│   │       ├── SwiftUI
│   │       │   ├── ImageBinder.swift
│   │       │   ├── ImageContext.swift
│   │       │   ├── KFAnimatedImage.swift
│   │       │   ├── KFImage.swift
│   │       │   ├── KFImageOptions.swift
│   │       │   ├── KFImageProtocol.swift
│   │       │   └── KFImageRenderer.swift
│   │       ├── Utility
│   │       │   ├── Box.swift
│   │       │   ├── CallbackQueue.swift
│   │       │   ├── Delegate.swift
│   │       │   ├── DisplayLink.swift
│   │       │   ├── ExtensionHelpers.swift
│   │       │   ├── Result.swift
│   │       │   ├── Runtime.swift
│   │       │   ├── SizeExtensions.swift
│   │       │   └── String+MD5.swift
│   │       └── Views
│   │           ├── AnimatedImageView.swift
│   │           └── Indicator.swift
│   ├── Local Podspecs
│   ├── Manifest.lock
│   ├── Pods.xcodeproj
│   │   ├── project.pbxproj
│   │   └── xcuserdata
│   │       └── simgwanhyeok.xcuserdatad
│   │           └── xcschemes
│   │               ├── Alamofire-Alamofire.xcscheme
│   │               ├── Alamofire.xcscheme
│   │               ├── Kingfisher-Kingfisher.xcscheme
│   │               ├── Kingfisher.xcscheme
│   │               ├── Pods-Moview.xcscheme
│   │               └── xcschememanagement.plist
│   └── Target Support Files
│       ├── Alamofire
│       │   ├── Alamofire-Info.plist
│       │   ├── Alamofire-dummy.m
│       │   ├── Alamofire-prefix.pch
│       │   ├── Alamofire-umbrella.h
│       │   ├── Alamofire.debug.xcconfig
│       │   ├── Alamofire.modulemap
│       │   ├── Alamofire.release.xcconfig
│       │   └── ResourceBundle-Alamofire-Alamofire-Info.plist
│       ├── Kingfisher
│       │   ├── Kingfisher-Info.plist
│       │   ├── Kingfisher-dummy.m
│       │   ├── Kingfisher-prefix.pch
│       │   ├── Kingfisher-umbrella.h
│       │   ├── Kingfisher.debug.xcconfig
│       │   ├── Kingfisher.modulemap
│       │   ├── Kingfisher.release.xcconfig
│       │   └── ResourceBundle-Kingfisher-Kingfisher-Info.plist
│       └── Pods-Moview
│           ├── Pods-Moview-Info.plist
│           ├── Pods-Moview-acknowledgements.markdown
│           ├── Pods-Moview-acknowledgements.plist
│           ├── Pods-Moview-dummy.m
│           ├── Pods-Moview-frameworks-Debug-input-files.xcfilelist
│           ├── Pods-Moview-frameworks-Debug-output-files.xcfilelist
│           ├── Pods-Moview-frameworks-Release-input-files.xcfilelist
│           ├── Pods-Moview-frameworks-Release-output-files.xcfilelist
│           ├── Pods-Moview-frameworks.sh
│           ├── Pods-Moview-umbrella.h
│           ├── Pods-Moview.debug.xcconfig
│           ├── Pods-Moview.modulemap
│           └── Pods-Moview.release.xcconfig
└── README.md

71 directories, 224 files
```
