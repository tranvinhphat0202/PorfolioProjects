-- Cleaning data in SQL queries

select * from NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(date,SaleDate)
From NashvilleHousing

--Update NashvilleHousing
--set SaleDate=CONVERT(date,SaleDate) Not working?

Alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = Convert(date,SaleDate)

-- Populate Property Address data

Select *
From NashvilleHousing
--where PropertyAddress is null
order by ParcelID  -- Find sth that there are some case 1 ParcelID have more than 1 propertyAddress and they are same

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) 
from NashvilleHousing a join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing
--where PropertyAddress is null
--order by ParcelID  

select 
substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

Select *
From NashvilleHousing

Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From NashvilleHousing

-- Change Y and N to Yes and No in "Solid and Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant 
,CASE when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 Else SoldAsVacant
	 End
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant='Y' then 'Yes'
						when SoldAsVacant='N' then 'No'
						Else SoldAsVacant
						End

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From NashvilleHousing

-- Delete unused columns

Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate