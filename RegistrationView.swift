struct RegistrationView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case fullName, email, password
    }

    var body: some View {
        VStack {
            TextField("Full Name", text: $viewModel.fullName)
                .textContentType(.name)
                .focused($focusedField, equals: .fullName)
                .padding()
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .focused($focusedField, equals: .email)
                .padding()
            SecureField("Password", text: $viewModel.password)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .padding()
            Button("Sign Up") {
                viewModel.signUp()
            }
            .disabled(!viewModel.isValid)
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage))
            }
            .padding()
        }
        .onAppear {
            focusedField = .fullName
        }
    }
}