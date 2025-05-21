//
//  FilterView.swift
//  Makanan
//
//  Created by Eliza Vornia on 05/05/25.
//
import SwiftUI

struct FilterView: View {
    @Binding var selectedFilters: [String: Set<String>]  // Set untuk multiple selections
    var applyFilters: () -> Void
    @Environment(\.dismiss) var dismiss


        var body: some View {
            NavigationStack {
                VStack {
                    Text("Filters")
                        .font(.title)
                        .padding(.top, -30)

                    Group {
                        FilterButton(
                            segmentTitle: "Lokasi",
                            itemTitle: ["GOP 1", "GOP 6", "GOP 9"],
                            selectedFilters: $selectedFilters
                        )
                        FilterButton(
                            segmentTitle: "Harga",
                            itemTitle: ["<Rp15.000", "<Rp25.000", ">=Rp25.000"],
                            selectedFilters: $selectedFilters
                        )
                        FilterButton(
                            segmentTitle: "Kategori",
                            itemTitle: ["Nasi", "Mie", "Cemilan", "Sayuran", "Berkuah", "Minuman"],
                            selectedFilters: $selectedFilters
                        )
                        FilterButton(
                            segmentTitle: "Rating",
                            itemTitle: [">1", ">2", ">3", ">4", "5"],
                            selectedFilters: $selectedFilters
                        )
                        FilterButton(
                            segmentTitle: "Pernah Dipesan",
                            itemTitle: ["Yes", "No"],
                            selectedFilters: $selectedFilters,
                            isSingleSelection: true
                        )
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, -8)

                    Spacer()

                    VStack {
                        Text("Total: \(selectedFilters.reduce(0) { $0 + $1.value.count }) filter diterapkan")
                            .font(.headline)
                        
                        HStack {
                            // Tombol Reset
                            Button(action: {
                                selectedFilters = [:]
                            }) {
                                Text("Atur Ulang")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                        
                                    .frame(width: 140, height: 50, alignment: .center)
                                
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(.white)

                                    .cornerRadius(8)
                                    .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 1, green: 0.44, blue: 0.24), lineWidth: 1)

                                    )
                                
                            }
                            
                            // Tombol Terapkan
                            Button(action: {
                                applyFilters()
                                dismiss()
                            }) {
                                Text("Terapkan")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .frame(width: 140, height: 50, alignment: .center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color(red: 1, green: 0.44, blue: 0.24))

                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }

struct FilterButton: View {
    var segmentTitle: String
    var itemTitle: [String]
    @Binding var selectedFilters: [String: Set<String>]
    var isSingleSelection: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(segmentTitle)
                .font(.headline)
                .padding(.top, 5)

            // ScrollView untuk horizontal scroll jika item terlalu banyak
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(itemTitle, id: \.self) { option in
                        Button(action: {
                            toggleSelection(for: option)
                        }) {
                            Text(option)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(isSelected(option) ? Color.orange : Color.gray.opacity(0.2))
                                .foregroundColor(isSelected(option) ? .white : .gray)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func isSelected(_ option: String) -> Bool {
        selectedFilters[segmentTitle]?.contains(option) ?? false
    }

    private func toggleSelection(for option: String) {
        if isSingleSelection {
            if selectedFilters[segmentTitle]?.contains(option) == true {
                selectedFilters.removeValue(forKey: segmentTitle)
            } else {
                selectedFilters[segmentTitle] = [option]
            }
        } else {
            if selectedFilters[segmentTitle]?.contains(option) == true {
                selectedFilters[segmentTitle]?.remove(option)
                if selectedFilters[segmentTitle]?.isEmpty == true {
                    selectedFilters.removeValue(forKey: segmentTitle)
                }
            } else {
                selectedFilters[segmentTitle, default: []].insert(option)
            }
        }
    }
}

#Preview {
    FilterView(selectedFilters: .constant([:]), applyFilters: {})
}
