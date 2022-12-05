//
//  AuthBirthday.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//


import SwiftUI
import Combine

struct AuthBirthday: View {
    @Binding var model: RegistrationModel
    
    @StateObject var birthdayFormFields = BirthdayFormFields()
    @FocusState private var focusedField: BirthdayForm?
    @State private var navigate: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter
    }
    
    var body: some View {
        ZStack {
            VStack( alignment: .leading, spacing: 30) {
                
                TextHelper(text: NSLocalizedString("yourBirthday", comment: ""),
                fontName: "Inter-SemiBold",
                fontSize: 30)
                
                TextHelper(text: NSLocalizedString("onlyAgeWillBeSeen", comment: ""))
                
                HStack {
                    BirthdayFields(placeholder: "DD", width: 61, date: $birthdayFormFields.day)
                        .focused($focusedField, equals: .day)
                    
                    BirthdayFields(placeholder: "MM", width: 61, date: $birthdayFormFields.month)
                        .focused($focusedField, equals: .month)
                    
                    
                    BirthdayFields(placeholder: "YYYY", width: 72, date: $birthdayFormFields.year)
                        .focused($focusedField, equals: .year)
                }
                
                Spacer()
                
                ButtonHelper(disabled: !birthdayFormFields.isProceedButtonClickable,
                             label: NSLocalizedString("continue", comment: "")) {
                    
                    let date = dateFormatter.date(from: "\(birthdayFormFields.day)/\(birthdayFormFields.month)/\(birthdayFormFields.year)")
                    
                    model.birthday = date ?? .now
                    navigate = true
                }.navigationDestination(isPresented: $navigate, destination: {
                    AuthGenderPicker(model: $model)
                })
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
                .padding(30)
            
            AuthProgress(page: 1)
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: birthdayFormFields.day) { value in
                if value.count == 2 {
                    focusedField = .month
                }
            }.onChange(of: birthdayFormFields.month) { value in
                if value.count == 2 {
                    focusedField = .year
                }
            }.onChange(of: birthdayFormFields.year) { value in
                if value.count == 4 {
                    focusedField = nil
                }
            }
    }

}

struct AuthBirthday_Previews: PreviewProvider {
    static var previews: some View {
        AuthBirthday(model: .constant(RegistrationModel()))
    }
}


class BirthdayFormFields: ObservableObject {
    let cur_year = Calendar.current.component(.year, from: Date())

    @Published var day: String = ""
    @Published var month: String = ""
    @Published var year: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var isProceedButtonClickable: Bool = false
    
    init() {
        allPublishersValid
            .receive(on: RunLoop.main)
            .assign(to: \.isProceedButtonClickable, on: self)
            .store(in: &cancellableSet)
    }
    
    
    private var isDayPublisherValid: AnyPublisher<Bool, Never> {
        $day
            .map { $0.count == 2 && Int($0) ?? 0 < 32}
            .eraseToAnyPublisher()
    }
    
    private var isMonthPublisherValid: AnyPublisher<Bool, Never> {
        $month
            .map { $0.count == 2 && Int($0) ?? 0 < 13}
            .eraseToAnyPublisher()
    }
    
    private var isYearPublisherValid: AnyPublisher<Bool, Never> {
        $year
            .map { $0.count == 4 &&
                Int($0) ?? 0 <= self.cur_year - 18 &&
                Int($0) ?? 0 >= self.cur_year - 90}
            .eraseToAnyPublisher()
    }
    
    private var allPublishersValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isDayPublisherValid, isMonthPublisherValid, isYearPublisherValid)
            .map{ a, b, c in
                return a && b && c
            }.eraseToAnyPublisher()
    }
}
