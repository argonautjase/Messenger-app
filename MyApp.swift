@main
struct MyApp: App {
    @StateObject private var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}