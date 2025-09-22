//
//  LoginView.swift
//  Test02
//
//  Created by mac25 on 9/15/25.
//

import SwiftUI
// 클래스 원본이름 모두 대문자
// 인스턴스화 앞에단어만 소문자
// loginview
// 카멜표기법을 따라야지...

struct LoginView: View {
    @State var id:String="" // 전역변수
    @State var pwd:String=""
    // X
    var body: some View {
        // UI 추가
        // dpi
        VStack{
            HStack {
                Text("ID")
                TextField("ID 입력", text: $id).onChange(of: id) { oldValue, newValue in
                    print("\(oldValue) \(newValue)")
                }
            }
            HStack{
                Text("PWD")
                TextField("PWD 입력", text: $pwd)
            }
            
            Button("로그인") {
                print("로그인")
                var a=10
                let b=20
                var c:String="aaaaa"
                
                // print("a + b = \(a+b) \(c)"+c)
                print("id : \(id)")
                print("pwd : \(pwd)")
                if id.count < 4{
                    print("ID를 입력해 주세요")
                }
            }
            
        }
        .padding(.horizontal, 30.0)
        
    }
}

#Preview {
    LoginView()
}
