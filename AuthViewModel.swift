import SwiftUI
import Firebase
import Combine
import LocalAuthentication

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isValid = false
    
    @Published var email = "" {
        didSet { validate() }
    }
    @Published var password = "" {
        didSet { validate() }
    }
    @Published var fullName = "" {
        didSet { validate() }
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest3($email, $password, $fullName)
            .map { email, password, fullName in
                return self.isValidEmail(email) && self.isValidPassword(password) && !fullName.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }

    private func validate() {
        isValid = isValidEmail(email) && isValidPassword(password) && !fullName.isEmpty
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("DEBUG: Sign Up Error - \(error.localizedDescription)")
                return
            }
            self.isAuthenticated = true
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("DEBUG: Login Error - \(error.localizedDescription)")
                return
            }
            self.isAuthenticated = true
        }
    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("DEBUG: Reset Password Error - \(error.localizedDescription)")
                return
            }
        }
    }

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in with Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription
                    }
                }
            }
        } else {
            // No biometrics available
            self.errorMessage = error?.localizedDescription
        }
    }
}
