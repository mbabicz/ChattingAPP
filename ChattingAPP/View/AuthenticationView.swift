//
//  AuthenticationView.swift
//  ShoppingApp
//
//  Created by kz on 01/02/2023.
//
import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var user: UserViewModel

    var body: some View {
        VStack {
            SignInView()
        }
        .alert(isPresented: $user.showingAlert){
            Alert(
                title: Text(user.alertTitle),
                message: Text(user.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

struct SignInView: View {
    
    @EnvironmentObject var user: UserViewModel

    @State var email = ""
    @State var password = ""

    @State var isSecured: Bool = true
    
    var body: some View {
        VStack {
            VStack{
                VStack{
                    TextField("Email", text: $email).padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                    ZStack(alignment: .trailing){
                        Group{
                            if isSecured {
                                SecureField("Password", text: $password).padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            } else {
                                TextField("Password", text: $password).padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            }
                        }
                        Button {
                            isSecured.toggle()
                        } label: {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye").accentColor(.gray)
                        }.padding()
                        
                    }
                    
                    NavigationLink("Reset your password", destination: ResetPasswordView())
                        .padding([.leading, .bottom, .trailing])
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(Color.green)
                    
                    Button {
                        if (!email.isEmpty && !password.isEmpty){
                            user.signIn(email: email, password: password)
                        } else{
                            user.alertTitle = "Error"
                            user.alertMessage = "Fields cannot be empty"
                            user.showingAlert = true
                        }

                    } label: {
                        Text("Sign in")
                            .frame(width: 200, height: 50)
                            .bold()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(45)
                            .padding()

                    }

                    Text("Don't have an account yet?")
                        .padding([.top, .leading, .trailing])
                    NavigationLink("Sign up", destination: SignUpView()).padding([.leading, .bottom, .trailing]).foregroundColor(Color.green)

                }
                .padding()
                Spacer()

            }
            .navigationTitle("Sign in")

        }
        
    }
    
}

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    @State var username = ""
    
    @EnvironmentObject var user: UserViewModel

    @State var isSecured: Bool = true
    @State var isSecuredConfirmation: Bool = true


    var body: some View {
        VStack {
            VStack{
                VStack{
                    TextField("Username", text: $username)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                    
                    TextField("Email", text: $email)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                    
                    ZStack(alignment: .trailing){
                        Group{
                            if isSecured {
                                SecureField("Password", text: $password)
                                    .padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            } else {
                                TextField("Password", text: $password)
                                    .padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            }
                        }
                        Button {
                            isSecured.toggle()
                        } label: {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }
                        .padding()
                        
                    }
                    
                    ZStack(alignment: .trailing){
                        Group{
                            if isSecuredConfirmation {
                                SecureField("Password", text: $passwordConfirmation)
                                    .padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            } else {
                                TextField("Password", text: $passwordConfirmation)
                                    .padding()
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .background(Color(.secondarySystemBackground))
                            }
                        }
                        Button {
                            isSecuredConfirmation.toggle()
                        } label: {
                            Image(systemName: self.isSecuredConfirmation ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }.padding()
                        
                    }
                    
                    Button {
                        if (!username.isEmpty && !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty ){
                            if password == passwordConfirmation {
                                user.signUp(email: email, password: password, username: username)
                            }
                            else{
                                user.alertTitle = "Error"
                                user.alertMessage = "Passwords must be the same"
                                user.showingAlert = true
                            }
                            
                        } else {
                            user.alertTitle = "Error"
                            user.alertMessage = "Fields cannot be empty"
                            user.showingAlert = true
                        }
                        
                    } label: {
                        Text("Create account")
                            .frame(width: 200, height: 50)
                            .bold()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(45)
                            .padding()

                    }

                }
                .padding()
                Spacer()
            }
            .navigationTitle("Create account")

        }
        
    }
    
}

struct ResetPasswordView: View {
    
    @State var email = ""
    
    @EnvironmentObject var user: UserViewModel
    
    var body: some View {
        VStack {
            VStack{
                VStack{
                    
                    TextField("Email", text: $email).padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(.secondarySystemBackground))
                    
                }
                
                Button {
                    if !email.isEmpty {
                        user.resetPassword(email: email)
                        
                    } else {
                        user.alertTitle = "Error"
                        user.alertMessage = "Fields cannot be empty"
                        user.showingAlert = true
                    }
                    
                } label: {
                    Text("Reset password")
                        .frame(width: 200, height: 50)
                        .bold()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(45)
                        .padding()
                }
                
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Recover password")
        
    }
    
}
