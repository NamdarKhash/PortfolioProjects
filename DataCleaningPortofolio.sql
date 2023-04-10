select *
from PortfolioProject..Housing

--Standadize Date Format
Select SaleDate, CONVERT(Date,SaleDate) as SaleDateConverted
from PortfolioProject..Housing

update Housing
set SaleDate=CONVERT(Date,SaleDate)

alter table Housing
add SaleDateConverted Date 

update housing
set SaleDate= CONVERT(date,SaleDate)

--Populate Property Address
select *
from PortfolioProject..Housing
where PropertyAddress is not null 
order by ParcelID


select a.ParcelId,a.PropertyAddress, b.ParcelId,b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..housing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress= isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..housing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null





--Breaking out Address into Individual Columns (Address,City,State)


select PropertyAddress
from PortfolioProject.dbo.Housing


select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as address
,substring(PropertyAddress, charindex(',', PropertyAddress)+1,LEN(PropertyAddress)) as address
from PortfolioProject.dbo.Housing

alter table Housing
add PropertysSplitAddress nvarchar (255) 

update housing
set PropertysSplitAddress= substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table Housing
add propertysplitcity nvarchar(255)

update housing
set propertysplitcity= substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))


select *
from PortfolioProject.dbo.Housing



select owneraddress
from PortfolioProject.dbo.Housing


select
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from PortfolioProject.dbo.Housing

alter table Housing
add OwnerSplitAddress nvarchar (255) 

update housing
set OwnerSplitAddress= parsename(replace(owneraddress,',','.'),3)

alter table Housing
add Ownersplitcity nvarchar(255)

update housing
set Ownersplitcity=parsename(replace(owneraddress,',','.'),2)

ALTER TABLE Housing
add Ownersplitstate nvarchar(255)

update housing
set Ownersplitstate=parsename(replace(owneraddress,',','.'),1)

select *
from portfolioProject.dbo.housing





--Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct (SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.Housing
group by SoldAsVacant
order by 2


select soldAsVacant
, Case WHEN SoldAsVacant ='Y' then 'Yes'
	when SoldAsVacant ='N' then 'No'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.Housing



UPDATE housing
SET soldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant ='N' THEN 'No'
	ELSE SoldAsVacant
	END




-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_Number() over (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				) row_num

from PortfolioProject.dbo.Housing
--ORDER BY ParcelID
)


SELECT *
from RowNumCTE
where row_num > 1
Order By PropertyAddress



--DELETE Unused Columns


Select *
from PortfolioProject.dbo.Housing

ALTER TABLE PortfolioProject.dbo.housing 
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.housing 
DROP COLUMN SaleDate