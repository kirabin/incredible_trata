//
//  ExtensionAddCAtegoryVC.swift
//  incredible_trata
//
//  Created by Aristova Alina on 03.11.2021.
//  
//

import Foundation
import UIKit

extension AddCategoryViewController: UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as?
                CategoryCollectionViewCell else {
                    fatalError()
                }
        cell.layer.cornerRadius = 10
        cell.backgroundColor = Color.iconBG
        cell.image = Default.imageNames[indexPath.row]
       return cell
    }

    private func collectionView(collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    private func collectionView(collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageNumber = indexPath.row
    }
}
