

select *
From Project.dbo.housing

Select DATA_TYPE, COLUMN_NAME
From INFORMATION_SCHEMA.COLUMNS

Select SaleDate, CAST(SaleDate as Date)
From Project..housing

-- Date Only column

Alter table housing
add SalesDate Date;

Update housing
set SalesDate = CAST(SaleDate as Date)

--Filling NUll Adress Data

Update a
set a.PropertyAddress = v.PropertyAddress
From Project..housing a
join Project..housing v on a.ParcelID=v.ParcelID and  a.UniqueID<>v.UniqueID
Where a.PropertyAddress is Null

Select a.PropertyAddress ,v.PropertyAddress,isnull(a.PropertyAddress ,v.PropertyAddress)
From Project..housing a
join Project..housing v on a.ParcelID=v.ParcelID and  a.UniqueID<>v.UniqueID
Where a.PropertyAddress is Null

--Dividing address column

Alter table housing
add Address nvarchar(255),City nvarchar(255);

Update housing
set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
	City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

--Spliting owner address

Alter table housing
add Owner_Address nvarchar(255),Owner_City nvarchar(255),Owner_State nvarchar(255);

Update housing
set Owner_Address = PARSENAME(Replace(OwnerAddress,',','.'),3)

Update housing
set Owner_City = PARSENAME(Replace(OwnerAddress,',','.'),2)

Update housing
set Owner_State = PARSENAME(Replace(OwnerAddress,',','.'),1)

--Renaming cells in SoldasVacant

Update housing
set SoldAsVacant = 'Yes'
where SoldAsVacant = 'Y'

Update housing
set SoldAsVacant = 'No'
where SoldAsVacant = 'N'

--Removing Duplicates
with Duplicate as(
Select *, ROW_NUMBER() over (Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as Duplicate_checker
From Project..housing
)
Delete
From Duplicate
where Duplicate_checker>1


--Removing columns

Alter Table housing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate




