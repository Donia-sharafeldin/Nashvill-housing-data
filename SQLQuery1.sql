SELECT *
  FROM portofolio.dbo.Nashvill
-- sale date converted

Alter table dbo.Nashvill
add SaleDatecon Date 

Update Nashvill
Set SaleDatecon = CONVERT(Date,SaleDate)


-- Property address null values

Update a 
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  FROM portofolio.dbo.Nashvill a
  join portofolio.dbo.Nashvill b
  on a.ParcelID = b.ParcelID and a.UniqueID != b.UniqueID
  where a.PropertyAddress is null

-- Check for null values updated

Select * 
FROM portofolio.dbo.Nashvill a
  join portofolio.dbo.Nashvill b
  on a.ParcelID = b.ParcelID and a.UniqueID != b.UniqueID
  where a.PropertyAddress is null

-- Getting Property address and city in separate columns --

Alter Table Nashvill
add PropertyCity Nvarchar(255)

Alter Table Nashvill
add PropertyAddressO Nvarchar(255)

Update Nashvill
set PropertyAddressO =PARSENAME(replace(PropertyAddress,',','.'),2)

Update Nashvill
Set PropertyCity = PARSENAME(replace(PropertyAddress,',','.'),1)

-- Getting Owner address and city in separate columns --

Alter Table Nashvill
add OwnerAddressO Nvarchar(255)
Update Nashvill
set OwnerAddressO = PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table Nashvill
add OwnerCity Nvarchar(255)
Update Nashvill
set OwnerCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table Nashvill
add OwnerState Nvarchar(255)
Update Nashvill
set OwnerState = PARSENAME(Replace(OwnerAddress,',','.'),1)

------------------------------------------------------

-- SoldAsVacant distinct values

Select distinct(SoldAsVacant)
FROM portofolio.dbo.Nashvill 
-- y& N to yes & no

Update portofolio.dbo.Nashvill 
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End

-- Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddressO,
				 SalePrice,
				 SaleDatecon,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM portofolio.dbo.Nashvill 

--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1

ALTER TABLE  portofolio.dbo.Nashvill 

DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
