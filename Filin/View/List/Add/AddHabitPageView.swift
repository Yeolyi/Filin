//
//  AddHabitPageView.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/08.
//

import SwiftUI

struct HabitPageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 5
    var body: some View {
        VStack {
            HabitPageViewController(pages: pages, currentPage: $currentPage)
            Text(String(currentPage))
        }
    }
}

struct HabitPageViewController<Page: View>: UIViewControllerRepresentable {
    let pages: [Page]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true
        )
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil
            }
            return controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return nil
            }
            return controllers[index + 1]
        }
        
        var parent: HabitPageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: HabitPageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
    }
}

struct HabitPageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HabitPageView(pages: Array(0...10).map(String.init).map { str in
                Text(str)
                    .frame(width: 100, height: 100)
                    .border(Color.black)
            })
            .frame(width: 200, height: 200)
            .border(Color.black)
        }
    }
}
