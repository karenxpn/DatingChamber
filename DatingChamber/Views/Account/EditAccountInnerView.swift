//
//  EditAccountInnerView.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 23.11.22.
//

import SwiftUI
import TagLayoutView

struct EditAccountInnerView: View {
    @State var user: UserModelViewModel
    @State private var showBirthdayPicker: Bool = false
    
    let icons = ["occupation_icon", "education_icon", "gender_icon", "city_icon"]
    let names = [NSLocalizedString("occupation", comment: ""),
                 NSLocalizedString("education", comment: ""),
                 NSLocalizedString("gender", comment: ""),
                 NSLocalizedString("city", comment: "")]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // profile image here
                ZStack( alignment: .bottomTrailing) {
                    
                    ImageHelper(image: user.avatar, contentMode: .fill)
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                    
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .fill(.white)
                            .frame(width: 25, height: 25)
                        
                        Image("edit_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 11, height: 11)
                            .padding(10)
                            .background(AppColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .shadow(radius: 2)
                    }
                    
                }
                
                // image gallery here
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(user.images, id: \.self) { image in
                            ImageHelper(image: image, contentMode: .fill)
                                .frame(width: 92, height: 92)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }                                .frame(height: 92)

                }
                
                // birthday here
                Button {
                    showBirthdayPicker.toggle()
                } label: {
                    HStack {
                        Image("calendar")
                            .padding(.leading, 20)
                        TextHelper(text: user.stringBirthday, color: AppColors.primary, fontName: "Inter-SemiBold", fontSize: 14)
                        Spacer()
                    }.frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.light_red)
                        )
                }
                
                // bio here
                
                EditBio(bio: $user.bio)
                
                // specs here
                VStack( spacing: 5) {
                    AccountSpecs(icon: icons[0], label: names[0], value: user.occupation, destination: AnyView(EditOccupation(user: $user)))
                    AccountSpecs(icon: icons[1], label: names[1], value: user.education, destination: AnyView(EditEducation(user: $user)))
                    AccountSpecs(icon: icons[2], label: names[2], value: user.gender, destination: AnyView(EditGender(user: $user)))
                    AccountSpecs(icon: icons[3], label: names[3], value: user.city, destination: AnyView(EditCity(user: $user)))
                }
                
                // interests here
                VStack(alignment: .leading, spacing: 19, content: {
                    HStack {
                        TextHelper(text: NSLocalizedString("interests", comment: ""), fontName: "Inter-SemiBold", fontSize: 18)
                        
                        Spacer()
                        
                        NavigationLink {
                            EditInterests(user: user)
                        } label: {
                            TextHelper(text: NSLocalizedString("edit", comment: ""), color: AppColors.primary, fontSize: 12)
                                .padding(.leading)
                        }
                    }
                    TagLayoutView(
                        user.interests, tagFont: UIFont(name: "Inter-Regular", size: 12)!,
                        padding: 20,
                        parentWidth: UIScreen.main.bounds.width * 0.8) { tag in
                            
                            Text(tag)
                                .fixedSize()
                                .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                .foregroundColor( .white)
                                .background(RoundedRectangle(cornerRadius: 30)
                                    .fill(AppColors.primary)
                                )
                            
                        }.padding(.leading, 1)
                })

                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
        }.padding(.top, 1)
        .sheet(isPresented: $showBirthdayPicker) {
            EditBirthday(user: $user)
                .presentationDetents([.large, .medium])
        }
    }
}

struct EditAccountInnerView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountInnerView(user: UserModelViewModel(user: AppPreviewModel.userModel))
    }
}
