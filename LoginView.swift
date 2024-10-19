struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .focused($focusedField, equals: .email)
                .padding()
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .padding()
            Button("Login") {
                viewModel.login()
            }
            .disabled(!viewModel.isValid)
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage))
            }
            .padding()
            Button("Reset Password") {
                viewModel.resetPassword()
            }
            .padding()
            Button("Login with Face ID") {
                viewModel.authenticateWithFaceID()
            }
            .padding()
        }
        .onAppear {
            focusedField = .email
        }
    }
}
