select
	Company
	, EmpID
	, LastName
	, Name
	, PRSetupReq
	, EmpStatus
	, ExpenseCode
	, ProductionWorker
	, MaterialHandler
	, ShopSupervisor
	, CanReportQty
	, CanOverrideJob
	, CanRequestMaterial
	, CanReportScrapQty
	, CanReportNCQty
	, ShipRecv
	, CnvEmpID
	, WarehouseManager
	, CanOverrideAllocations
	, AllowDirLbr
	, CanEnterIndirectTime
	, CanEnterProductionTime
	, CanEnterProjectTime
	, CanEnterServiceTime
from
	Erp.EmpBasic