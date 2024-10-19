struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            AddView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
            AdminView()
                .tabItem {
                    Label("Admin", systemImage: "gearshape")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}