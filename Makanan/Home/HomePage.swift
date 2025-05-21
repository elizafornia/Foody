//
//  HomePage.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
import SwiftUI
import SwiftData

struct HomePage: View {
    @State private var searchText: String = ""
    @State private var isShowFilter: Bool = false
    @State var selectedFilters: [String: Set<String>] = [:]
    @State private var tempFilters: [String: Set<String>] = [:]
    @State private var navigateToFavorit = false
    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var showBanner: Bool = true
    @State private var selectedStall: Stall?
    @State private var navigateToShake = false
    @State private var showFavoriteToast: Bool = false
    @State private var isSearchBarInToolbar = false
    
    @Query private var favoriteItems: [FavoriteItem]
    
    var stalls: [Stall] = Stall.all
    @Environment(\.modelContext) private var modelContext
    
    var groupedFavorites: [(stall: Stall, count: Int)] {
        let grouped = Dictionary(grouping: favoriteItems, by: { $0.stallName })
        return grouped.compactMap { (stallName, items) in
            if let stall = stalls.first(where: { $0.name == stallName }) {
                return (stall, items.count)
            }
            return nil
        }
        .sorted { $0.count > $1.count }
    }
    
    var filteredStalls: [Stall] {
        stalls.filter { stall in
            let matchesSearch = searchText.isEmpty ||
            stall.name.lowercased().contains(searchText.lowercased()) ||
            stall.location.lowercased().contains(searchText.lowercased())
            
            let matchesLocation = selectedFilters["Lokasi"].map { $0.contains(stall.location) } ?? true
            let matchesPrice = selectedFilters["Harga"].map { filters in
                filters.contains(where: { filter in
                    switch filter {
                    case "<Rp15.000": return stall.lowestPrice < 15000
                    case "<Rp25.000": return stall.lowestPrice < 25000
                    case ">=Rp25.000": return stall.highestPrice >= 25000
                    default: return false
                    }
                })
            } ?? true
            
            let matchesCategory = selectedFilters["Kategori"].map {
                $0.contains(where: { stall.category.contains($0) })
            } ?? true
            
            let matchesRating = selectedFilters["Rating"].map { filters in
                filters.contains(where: { filter in
                    if let ratingValue = Double(filter.replacingOccurrences(of: ">", with: "")) {
                        return stall.rating >= ratingValue
                    }
                    return false
                })
            } ?? true
            
            let matchesTriedBefore = selectedFilters["Pernah Dipesan"].map { filters in
                filters.contains(where: { filter in
                    if filter == "Yes" {
                        return stall.wasOrdered
                    } else if filter == "No" {
                        return !stall.wasOrdered
                    }
                    return false
                })
            } ?? true
            
            return matchesSearch && matchesLocation && matchesPrice && matchesCategory && matchesRating && matchesTriedBefore
        }
    }
    
    
    var body: some View {
           NavigationStack {
               ZStack {
                   VStack(spacing: 0) {
                       // Header
                       HStack {
                           Image("LogoFoody")
                               .resizable()
                               .frame(width: 100, height: 100)
                               .padding(.leading)
                           
                           Spacer()
                           
                           HStack(spacing: 16) {
                               Button(action: {
                                   navigateToFavorit = true
                               }) {
                                   Image(systemName: "heart")
                                       .font(.title2)
                               }
                               
                               Button(action: {
                                   tempFilters = selectedFilters
                                   isShowFilter = true
                               }) {
                                   Image(systemName: selectedFilters.isEmpty ? "line.3.horizontal" : "line.3.horizontal.decrease.circle.fill")
                                       .font(.title2)
                               }
                           }
                           .padding(.trailing)
                       }
                       .padding(.top)
                       
                       // Banner and Search Bar Section
                       if scrollOffset > -100 {
                           VStack(spacing: 0) {
                               if showBanner {
                                   Button(action: {
                                       navigateToShake = true
                                   }) {
                                       Image("banner")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(height: 180)
                                           .cornerRadius(12)
                                           .padding(.horizontal)
                                   }
                                   .buttonStyle(PlainButtonStyle())
                                   .padding(.bottom, 12)
                               }
                               
                               // Search Bar
                               HStack {
                                   Image(systemName: "magnifyingglass")
                                       .foregroundColor(.gray)
                                   TextField("Cari stall…", text: $searchText)
                                       .foregroundColor(.primary)
                               }
                               .padding()
                               .background(Color(.systemGray6))
                               .cornerRadius(20)
                               .padding(.horizontal)
                           }
                           .transition(.move(edge: .top).combined(with: .opacity))
                           .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                       }
                       
                       // Main Content (ScrollView, favorites dan stalls)
                       ScrollView {
                           VStack(alignment: .leading, spacing: 16) {
                               GeometryReader { geo in
                                   Color.clear
                                       .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                               }
                               .frame(height: 0)
                               
                               // Favorites Section (dalam ScrollView)
                               if !groupedFavorites.isEmpty {
                                   VStack(alignment: .leading, spacing: 8) {
                                       Text("Favorit Kamu")
                                           .font(.headline)
                                           .padding(.horizontal)
                                       
                                       ScrollView(.horizontal, showsIndicators: false) {
                                           LazyHStack(spacing: 16) {
                                               ForEach(groupedFavorites, id: \.stall.id) { item in
                                                   GroupFavoriteCard(
                                                       stall: item.stall,
                                                       menuCount: item.count
                                                   )
                                                   .fixedSize()
                                                   .id(item.stall.id)
                                               }
                                           }
                                           .padding(.horizontal)
                                       }
                                       .fixedSize(horizontal: false, vertical: true)
                                   }
                                   .padding(.vertical, 8)
                               }
                               
                               // Stall Section
                               Text("Stall")
                                   .font(.headline)
                                   .padding(.horizontal)
                               
                               ForEach(filteredStalls) { stall in
                                   Button(action: {
                                       selectedStall = stall
                                   }) {
                                       StallsCard(stall: stall)
                                           .padding(.horizontal, 16)
                                   }
                                   .buttonStyle(PlainButtonStyle())
                               }
                           }
                           .padding(.top)
                       }
                       .coordinateSpace(name: "scroll")
                       .onPreferenceChange(ScrollOffsetKey.self) { value in
                           
                           guard abs(value - previousScrollOffset) > 2 else { return }
                           
                           withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
                               let delta = value - previousScrollOffset
                               if delta > 5 {
                                   showBanner = true
                               } else if delta < -5 {
                                   showBanner = false
                               }
                               previousScrollOffset = value
                               scrollOffset = value
                           }
                       }
                    
                    
                    // Navigation Links
                    NavigationLink(
                        destination: FavoritPage()
                            .environment(\.modelContext, modelContext),
                        isActive: $navigateToFavorit
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
                    NavigationLink(
                        destination: ShakeView(viewModel: FavoriteViewModel(modelContext: modelContext)),
                        isActive: $navigateToShake
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
                    NavigationLink(
                        destination: selectedStall.map { stall in
                            MenuPage(stall: stall)
                                .environment(\.modelContext, modelContext)
                        },
                        isActive: Binding(
                            get: { selectedStall != nil },
                            set: { isActive in
                                if !isActive {
                                    selectedStall = nil
                                }
                            }
                        )
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
                
                // Toast
                if showFavoriteToast {
                    VStack {
                        Spacer()
                        Text("Berhasil ditambahkan ke favorit!")
                            .font(.subheadline)
                            .padding()
                            .background(Color.green.opacity(0.85))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut, value: showFavoriteToast)
                }
            }
            .sheet(isPresented: $isShowFilter) {
                FilterView(selectedFilters: $tempFilters) {
                    selectedFilters = tempFilters
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didAddFavorite)) { _ in
                print("📣 Notifikasi diterima: Menu berhasil ditambahkan ke favorit.")
                showFavoriteToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showFavoriteToast = false
                    }
                }
            }
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    HomePage()
        .modelContainer(for: OrderItem.self)
}
