//
//  SignUpView.swift
//  IP2025
//
//  Created by Chaemin Yu on 10/12/25.
//

import SwiftUI

struct SignUpView: View {
    // 입력값
    @State private var id: String = ""
    @State private var pwd: String = ""
    @State private var birthDate: Date = Date()        // DatePicker 사용
    @State private var gender: Gender = .female
    
    // 상태값
    @State private var isSubmitting: Bool = false
    @State private var isSucceedSignUp: Bool = false
    @State private var errorMessage: String? = nil
    @FocusState private var focusedField: Field?
    
    enum Field {
        case id, pwd
    }
    
    enum Gender: String, CaseIterable, Identifiable {
        case male = "male"
        case female = "female"
        var id: String { rawValue }
        var label: String {
            switch self {
            case .male: return "남성"
            case .female: return "여성"
            }
        }
    }
    
    // MARK: - Validation Rules
    private let bannedSpecials = "!@#$%^&" // ID 금지, PWD 필수 중 1개
    private var idIsValid: Bool {
        // ID 4글자 이상, 특수문자(!@#$%^&) 포함 금지
        guard id.count >= 4 else { return false }
        return id.range(of: "[!@#$%^&]", options: .regularExpression) == nil
    }
    private var pwdIsValid: Bool {
        // PWD 4글자 이상, 특수문자(!@#$%^&) 최소 1개, 숫자 최소 1개
        guard pwd.count >= 4 else { return false }
        let hasRequiredSpecial = pwd.range(of: "[!@#$%^&]", options: .regularExpression) != nil
        let hasDigit = pwd.range(of: "\\d", options: .regularExpression) != nil
        return hasRequiredSpecial && hasDigit
    }
    private var birthIsValid: Bool {
        // DatePicker 사용 시 형식 자체는 항상 유효
        true
    }
    private var allValid: Bool {
        idIsValid && pwdIsValid && birthIsValid
    }
    
    // yyyy-MM-dd 로 포맷
    private var birthString: String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "ko_KR")
        f.timeZone = TimeZone(secondsFromGMT: 0) // 서버 입력 안정성
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: birthDate)
    }
    
    var body: some View {
            VStack(spacing: 20) {
                NavigationLink(destination: MainView(), isActive: $isSucceedSignUp) {
                    EmptyView()
                }.hidden()
                
                Text("회원가입")
                    .font(.largeTitle).bold()
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        TextField("ID (4자 이상, !@#$%^& 금지)", text: $id)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .id)
                            .onSubmit { focusedField = .pwd }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(idIsValid ? .gray.opacity(0.4) : .red, lineWidth: 1))
                        
                        if !idIsValid && !id.isEmpty {
                            Text("ID는 4자 이상이어야 하며, 특수문자 \(bannedSpecials) 는 사용할 수 없습니다.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Group {
                        SecureField("PWD (4자 이상, 숫자 1+ & \(bannedSpecials) 중 1+ 포함)", text: $pwd)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .submitLabel(.done)
                            .focused($focusedField, equals: .pwd)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(pwdIsValid ? .gray.opacity(0.4) : .red, lineWidth: 1))
                        
                        if !pwdIsValid && !pwd.isEmpty {
                            Text("비밀번호는 4자 이상이며 숫자 1개 이상과 \(bannedSpecials) 중 1개 이상을 포함해야 합니다.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Group {
                        Text("생년월일")
                            .font(.headline)
                        DatePicker("생년월일", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    Group {
                        Text("성별")
                            .font(.headline)
                        Picker("성별", selection: $gender) {
                            ForEach(Gender.allCases) { g in
                                Text(g.label).tag(g)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(.horizontal, 20)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                }

                Button {
                    submitSignUp()
                } label: {
                    HStack {
                        if isSubmitting { ProgressView().padding(.trailing, 6) }
                        Text("가입하기")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(allValid ? Color.blue : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .disabled(!allValid || isSubmitting)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    
    // MARK: - Networking
    private func submitSignUp() {
        guard allValid else {
            errorMessage = "입력값을 확인해주세요."
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        guard let url = URL(string: "http://localhost/ip1/signup.php") else {
            isSubmitting = false
            errorMessage = "잘못된 서버 주소입니다."
            return
        }
        
        let params = [
            "id": id,
            "pwd": pwd,
            "birth": birthString,     // yyyy-MM-dd
            "gender": gender.rawValue // "male" / "female"
        ]
        let body = params
            .map { "\($0.key)=\((($0.value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")" }
            .joined(separator: "&")
        let bodyData = body.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "네트워크 오류: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { errorMessage = "서버 응답이 없습니다." }
                return
            }
            let str = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
            if str == "1" || str.lowercased() == "success" {
                DispatchQueue.main.async {
                    isSucceedSignUp = true
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "가입 실패: \(str)"
                }
            }
        }.resume()
    }
}

#Preview {
    SignUpView()
}

