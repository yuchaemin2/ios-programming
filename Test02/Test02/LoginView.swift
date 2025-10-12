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
    @State var name: String = "yuchaemin"
    @State var id:String="test1" // 전역변수
    @State var pwd:String="test1"
    @State var isSucceedLogin:Bool=false
    var age:Int = 30
    var body: some View {
        // UI 추가
        // dpi
        NavigationView {
            VStack{
                NavigationLink(destination: MainView(), isActive: $isSucceedLogin, label: {
                    
                })
                
                Button{
                    
                    guard let url=URL(string: "http://localhost/ip1/login.php")
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
                        
                        let str = String(decoding: data, as: UTF8.self)
                        
                        print("data ? \(str)")
                        
                        if str == "1"{
                            print("로그인 성공")
                            isSucceedLogin=true
                        }

                    }.resume()
                } label: {
                    Text("로그인")
                }
                
            }
            .padding(.horizontal, 30.0)
        }
        
    }
}

#Preview {
    LoginView()
}
