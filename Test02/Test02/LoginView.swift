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
        NavigationView {
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
                    if id.count < 4 {
                        print("ID를 입력해 주세요")
                    }
                    
                    guard let url=URL(string: "http://localhost/login.php")
                    else {
                        print("url error")
                        return
                    }
                    let body = "id=\(id)&pwd=\(pwd)"
                    let encodedData=body.data(using: String.Encoding.utf8)
                    
                    var request=URLRequest(url:url)
                    request.httpMethod="POST"
                    request.httpBody=encodedData
                    
                    URLSession.shared.dataTask(with: request){
                        (data,response,error) in
                        if let error = error{
                            print(error)
                            return
                        }
                        guard let data=data else{
                            return
                        }
                        
           
                    }.resume()
                }
                NavigationLink(destination: MainView()) {Text("로그인")}
            }
            .padding(.horizontal, 30.0)
        }
        
    }
}

#Preview {
    LoginView()
}
