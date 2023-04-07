--Cleaning Data in SQL Queries 

Select*
From [Portfolio Project].dbo.Nashvillehousing 

--Standardize Date Format 

Select SaleDate, Convert(Date,Saledate)
From [Portfolio Project].dbo.NashvilleHousing 

Update NashvilleHousing 
Set SaleDate = Convert(date,SaleDate) 

Alter Table NashvilleHousing 
drop column SaleDateConverted;

--Populate Poperty Address data 

Select *
From [Portfolio Project].dbo.Nashvillehousing
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing as A
Join [Portfolio Project].dbo.NashvilleHousing as b 
	on a.ParcelID = b.ParceliD 
	And a.[uniqueId] <> b.[UniqueID]
Where a.PropertyAddress is Null 

Update A
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing as A
Join [Portfolio Project].dbo.NashvilleHousing as b 
	on a.ParcelID = b.ParceliD 
	And a.[uniqueId] <> b.[UniqueID]


--Breaking out address into Individual Colums (Address, City, State)

Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing 


--Where PropertyAddress is null
-- Order By ParcelID 

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, CHARINDEx(',', PropertyAddress)+1, LEN(PropertyAddress))as Address
From [Portfolio Project].dbo.NashvilleHousing

Alter Table NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255); 

update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table Nashvillehousing 
Add PropertySplitCity Nvarchar(255); 

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEx(',', PropertyAddress)+1, LEN(PropertyAddress))


Select * 
From [Portfolio Project]..Nashvillehousing 



Select OwnerAddress 
From [Portfolio Project]..Nashvillehousing 

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as StreetAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State

from [Portfolio Project]..Nashvillehousing

Alter Table NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing 
Add OwnerSplitCity NVARCHAR(255);

Update Nashvillehousing 
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState NVarchar(255);

Update NashvilleHousing 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select * 
From [Portfolio Project]..NashvilleHousing 



----

Select Distinct(SoldASVacant), Count(SoldAsVacant)
From [Portfolio Project]..NashvilleHousing 
group By SoldAsVacant 
Order by 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant 
end 

From [Portfolio Project]..Nashvillehousing 


Update NashvilleHousing 
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'NO' 
	Else SoldAsVacant 
	End


--Remove Duplicates 

With RowNumCTE as (
Select *, 
	Row_Number() Over
	(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate, 
				 LegalReference
				 Order By
					UniqueID
					) as Row_NUM 
From [Portfolio Project]..NashvilleHousing
--Order By ParcelId 
)
Select* 
From RowNumCTE 
Where Row_Num > 1
order by PropertyAddress

-- Delete Unused Column 

Select* 
From [Portfolio Project]..NashvilleHousing 


Alter Table NashvilleHousing 
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table NashvilleHousing 
Drop Column SaleDate
