//
//  LockView.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 23/06/24.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content : View>: View {
    
    var lockType : LockType
    var lockPin : String
    var isEnabled : Bool
    var lockWhenAppGoesBackground : Bool 
    @ViewBuilder var content : Content
    @State private var pin : String = ""
    var forgotPin : ()->() = {  }
    @State private var animateField : Bool = false
    @State private var isUnlocked : Bool = true
    @State private var noBiometricAccess : Bool = false
    let context = LAContext()
    @Environment(\.scenePhase) private var phase
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            content
                .frame(width: size.width , height: size.height)
            
            if isEnabled && !isUnlocked{
                ZStack{
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                    // if biomatric is on phone
                    if (lockType == .both && !noBiometricAccess)  || lockType == .biometric {
                        Group{
                            if noBiometricAccess {
                                NumberPadPinView()
                            }
                            else{
                                // biomatric and pin unlock
                                VStack(spacing:12){
                                    VStack(spacing:12){
                                        Image(systemName: "faceid")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                        Text("Tap to unlock")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.5))
                                            
                                    }.frame(width: .screenWidth*0.35, height: .screenWidth*0.35-2)
                                    .background(.clear , in: .rect(cornerRadius:15))
                                    .overlay{
                                        RoundedRectangle(cornerRadius:20)
                                            .stroke(.primary,lineWidth:2)
                                    }
                                     .contentShape(.rect)
                                     .onTapGesture {
                                         unlockview()
                                     }
                                    if lockType ==  .both {
                                        Text("Enter Password")
                                            .foregroundStyle(.white)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    }
                    // if no biometric on phone then
                    else{
                        NumberPadPinView()
                    }
                }.transition(.offset(y:size.height+100))
            }
        }
        .onChange(of: isEnabled,initial: true){oldValue , newValue in
            if newValue {
                unlockview()
            }
            
        }
        .onChange(of: phase){ oldValue , newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            if newValue == .active && !isUnlocked && isEnabled {
                unlockview()
            }
        }
    }
    
    private func unlockview() {
        Task {
            if isBiometricAvailable && lockType != .number{
                if let result = try? await
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View") , result {
                    print("Unlocked")
                    withAnimation(.snappy,completionCriteria:.logicallyComplete){
                        isUnlocked = true
                    }completion: {
                        pin = ""
                    }
                }
            }
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    private var isBiometricAvailable : Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error:nil)
    }
    
    @ViewBuilder
    func NumberPadPinView() -> some View{
        VStack(spacing:15){
            Text("Enter Pin")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both && isBiometricAvailable{
                        Button {
                            pin = ""
                            noBiometricAccess = false
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .tint(.white)
                                .contentShape(.rect)
                                
                        }.padding(.leading)
                            .padding(.top,2)

                    }
                }
            
            HStack(spacing:8){
                ForEach(0..<6,id:\.self){index in
                    RoundedRectangle(cornerRadius:10)
                        .frame(width:50,height:55)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex , offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            // MARK: shakingEffect
            // keyframe animator gives the shaking effect
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content , value in
                content
                    .offset(x:value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(10, duration: 0.07)
                    CubicKeyframe(-10, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .frame(maxHeight: .screenWidth)
             .overlay(alignment:.bottomTrailing){
                 Button("Forgot Password??", action: forgotPin)
                     .font(.title2)
                     .offset(y:-100)
                     .foregroundStyle(Color.secondary)
                     
            }
            //MARK: NumberPad
            GeometryReader{_ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9,id: \.self){number in
                        Button{
                            if pin.count < 6 {
                                pin.append("\(number)")
                            }
                        }label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth:.infinity)
                                .padding(.vertical,20)
                                .contentShape(.circle)
                                .tint(.white)
                        }
                        if number == 9 {
                            Text("")
                                .font(.title)
                                .frame(maxWidth:.infinity)
                                .padding(.vertical,20)
                                //.contentShape(.circle)
                                .tint(.blue)
                        }
                    }
                    // MARK: 0
                    Button{
                        if pin.count < 6 {
                            pin.append("0")
                        }
                    }label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,20)
                            .contentShape(.circle)
                            .tint(.white)
                    }
                    // MARK: back
                    Button{
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,20)
                            .contentShape(.circle)
                            .tint(.white)
                    }
                    
                })
                .frame(maxHeight: .infinity,alignment: .bottom)
            }
                .onChange(of: pin){oldValue , newValue in
                if newValue.count == 6 {
                    // if correct pin then
                    if lockPin == pin {
                    withAnimation(.snappy,completionCriteria: .logicallyComplete){
                        isUnlocked = true
                    } completion:{
                        pin = ""
                        noBiometricAccess = !isBiometricAvailable
                    }
                }
                    //if incorrect pin then
                    else{
                        withAnimation(.snappy(duration:0.07)){
                            pin = ""
                        }
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme , .dark)
    }
    
    enum LockType : String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First Preference will be biometric , if it is not available then will go for the number lock"
    }
}

#Preview {
    // preview me rahega content view function jaha se call hoga waha se parameter pass hoga
    ContentView()
}
