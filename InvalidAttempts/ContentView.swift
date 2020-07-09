//
//  ContentView.swift
//  InvalidAttempts
//
//  Created by Sarah Alsharif on 7/9/20.
//  Copyright © 2020 Sarah Alsharif. All rights reserved.
//

import SwiftUI
let lightGrey = Color(red: 240.0/255.0, green: 242.0/255.0, blue: 245.0/255.0, opacity: 1.0)

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    //  Image("logo").resizable().frame(width: 230, height: 230).offset(y: 30)
                    LoginView()//.offset(y: -80)
                }
            }
            .background(Color(#colorLiteral(red: 0.9671313167, green: 0.737631619, blue: 0.2703509033, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    @State var invalidAttempts = 0
    @State var showAlert = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var time = 10
    @State var isDisabled = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Login").font(.system(size: 40)).bold()//.frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                TextField("Username", text: $username)
            }
            .padding()
            .background(lightGrey)
            .cornerRadius(8)
            .padding(.bottom, 20)
            .keyboardType(.emailAddress)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.secondary)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(lightGrey)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(invalidAttempts == 0 ? Color.clear :Color.red)
            )
                .padding(.bottom, 20)
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
            
            Button(action:
                {
                    //forgot password
            }, label: {
                Text("Forgot password?").padding()
            }
            )
            
            
            Button(action:
                {
                    if self.invalidAttempts < 4 {
                        withAnimation(.default) {
                            self.invalidAttempts += 1
                        }
                    } else {
                        self.isDisabled.toggle()
                        self.showAlert.toggle()
                    }
            }, label: {
                Text("LOGIN")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250, height: 60)
                    .background(isDisabled ? Color.gray : Color.blue)
                    .cornerRadius(20)
                }
            ).onReceive(timer) { (_) in
                if self.isDisabled {
                    self.time -= 1
                    print(self.time)
                    if self.time == 0 {
                        self.time = 10
                        self.isDisabled.toggle()
                    }
                }
            }
            
            Spacer()
            HStack {
                Text("Don't have an account?")
                Button(action:
                    {
                        //sign up
                }, label: {
                    Text("Sign Up")
                }
                )
            }.padding(.bottom, 50)
        }.padding()
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text("Failed login"), message: Text("Too many failed attempts. Please try again in 5 minutes."), dismissButton: .default(Text("Ok")))
        }
    }
}




struct ShakeEffect : GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
