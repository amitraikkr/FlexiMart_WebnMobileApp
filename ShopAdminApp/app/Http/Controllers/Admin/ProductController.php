<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use League\Csv\Reader;
use App\Models\Product;
use Spatie\Permission\Models\Permission;
use App\Http\Controllers\Controller;

class ProductController extends Controller 
{
    public function __construct()
    {
        // Create permissions if they don't exist
        Permission::firstOrCreate(['name' => 'product-import-read', 'guard_name' => 'web']);
        Permission::firstOrCreate(['name' => 'product-import-create', 'guard_name' => 'web']);
    }

    public function import(Request $request)
    {
        $request->validate([
            'csv_file' => 'required|file|mimes:csv,txt'
        ]);

        try {
            $file = $request->file('csv_file');
            $csv = Reader::createFromPath($file->getPathname(), 'r');
            $csv->setHeaderOffset(0);

            $records = $csv->getRecords();
            
            foreach ($records as $record) {
                Product::create([
                    'productName' => $record['productName'],
                    'business_id' => auth()->user()->business_id,
                    'category_id' => $record['category_id'],
                    'brand_id' => $record['brand_id'] ?? null,
                    'unit_id' => $record['unit_id'] ?? null,
                    'productCode' => $record['productCode'] ?? null,
                    'productDealerPrice' => $record['productDealerPrice'] ?? 0,
                    'productPurchasePrice' => $record['productPurchasePrice'] ?? 0,
                    'productSalePrice' => $record['productSalePrice'] ?? 0,
                    'productWholeSalePrice' => $record['productWholeSalePrice'] ?? 0,
                    'productStock' => $record['productStock'] ?? 0,
                    'productManufacturer' => $record['productManufacturer'] ?? null,
                ]);
            }

            return response()->json([
                'message' => 'Products imported successfully',
                'redirect' => route('admin.products.index')
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error importing products: ' . $e->getMessage()
            ], 422);
        }
    }

    public function downloadSample()
    {
        $headers = [
            'productName',
            'category_id',
            'brand_id',
            'unit_id',
            'productCode',
            'productDealerPrice',
            'productPurchasePrice',
            'productSalePrice',
            'productWholeSalePrice',
            'productStock',
            'productManufacturer'
        ];

        $sample = [
            $headers,
            [
                'Sample Product',
                '1',  // category_id
                '1',  // brand_id
                '1',  // unit_id
                'PRD001',
                '100', // dealer price
                '80',  // purchase price
                '120', // sale price
                '110', // wholesale price
                '50',  // stock
                'Sample Manufacturer'
            ]
        ];

        $callback = function() use ($sample) {
            $file = fopen('php://output', 'w');
            foreach ($sample as $row) {
                fputcsv($file, $row);
            }
            fclose($file);
        };

        return response()->stream($callback, 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => 'attachment; filename="sample-products.csv"',
        ]);
    }

    public function showImport()
    {
        return view('admin.products.import');
    }
}
