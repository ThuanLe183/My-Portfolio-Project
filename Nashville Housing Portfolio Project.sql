USE [MyPortfolioProject]
select * 
from [dbo].[NashvilleHousing]

-- Chuẩn hóa SaleDate format

alter table [dbo].[NashvilleHousing]
add SaleDateConverted Date

Update [dbo].[NashvilleHousing]
set SaleDateConverted = CONVERT(Date , SaleDate)

select SaleDateConverted 
from [dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------------------------------

-- Tìm lại PropertyAddress biết rằng 1 ParcelID sẽ tương ứng với 1 Fixed PropertyAddress

select *
from [dbo].[NashvilleHousing]
order by ParcelID

select ParcelID,
from [dbo].[NashvilleHousing]
where ParcelID IS NULL ----- => Ko có giá trị nào mà PacelId null

select PropertyAddress,
from [dbo].[NashvilleHousing] 
where PropertyAddress is null ----- => Tìm ra được những giá trị có ParcelID mà không có PropertyAddress

Update a
set PropertyAddress = ISNULL (a.PropertyAddress , b.PropertyAddress)
from [dbo].[NashvilleHousing] a
join [dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

select * 
from [dbo].[NashvilleHousing]
where PropertyAddress is null -----=> Done

--------------------------------------------------------------------------------------------------------------
-- Chia cột địa chỉ thành những nhiều cột (Address , city , state)

select PropertyAddress
from [dbo].[NashvilleHousing]

select 
	SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) - 1 ) AS Address1 ,
	SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) + 1 , len(PropertyAddress)) AS Address2
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing]
add Address1 Nvarchar (255)

update [dbo].[NashvilleHousing]
set Address1 = SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) - 1 )

alter table [dbo].[NashvilleHousing]
add Address2 Nvarchar (255)	

update [dbo].[NashvilleHousing]
set Address2 = SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) + 1 , len(PropertyAddress))

select *
from [dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------------------------------
-- Thay đổi Y và N thành Yes và No cột SoldAsVacant

select distinct [SoldAsVacant]
from [dbo].[NashvilleHousing]

select SoldAsVacant
from [dbo].[NashvilleHousing]
where SoldAsVacant not in  ('N' , 'No' , 'Y' , 'Yes')

select distinct 
	SoldAsVacant,
	COUNT (SoldAsVacant) 
from [dbo].[NashvilleHousing]
group by SoldAsVacant
order by 1

select
	SoldAsVacant,
	CASE When SoldAsVacant ='Y' Then 'Yes'
		 When SoldAsVacant ='N' Then 'No'
		 ELSE SoldAsVacant
    END
from [dbo].[NashvilleHousing]

update [dbo].[NashvilleHousing]
set SoldAsVacant = CASE When SoldAsVacant ='Y' Then 'Yes'
					    When SoldAsVacant ='N' Then 'No'
				        ELSE SoldAsVacant
				   END

select distinct SoldAsVacant
from MyPortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------
-- Xóa giá trị lặp thông qua CTE 
With CTE AS (
select * ,
	ROW_Number () over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
						order by 
							UniqueID
							) row_num 
from [dbo].[NashvilleHousing]
)

select * 
from CTE
where row_num > 1 --- => Tìm ra được 104 giá trị bị lặp

With CTE AS (
select * ,
	ROW_Number () over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
						order by 
							UniqueID
							) row_num 
from [dbo].[NashvilleHousing]
)
delete 
from CTE
where row_num > 1

With CTE AS (
select * ,
	ROW_Number () over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
						order by 
							UniqueID
							) row_num 
from [dbo].[NashvilleHousing]
)
select * 
from CTE
where row_num > 1 

--------------------------------------------------------------------------------------------------------------
-- Xóa cột không cần thiết
select * 
from [dbo].[NashvilleHousing]

Alter table [dbo].[NashvilleHousing]
Drop column TaxDistrict

select  [TaxDistrict]
from [dbo].[NashvilleHousing] 