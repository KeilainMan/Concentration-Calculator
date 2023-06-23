using Godot;
using System;
using System.IO;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System.Collections;
using System.Collections.Generic;

public class DataPorter : Node
{

	public override void _Ready()
	{

	}

	public Godot.Collections.Array<Godot.Collections.Array<Godot.Collections.Array<string>>> ImportWorkbook(string filePath)
	{
		IWorkbook currentBook = ReadWorkbook(filePath);
		List<ISheet> sheetList = ReadAllSheets(currentBook);
		IEnumerator<ISheet> sheetEnumerator = sheetList.GetEnumerator(); 
		Godot.Collections.Array<Godot.Collections.Array<Godot.Collections.Array<string>>> dataInSheetsInRowsInStrings = new Godot.Collections.Array<Godot.Collections.Array<Godot.Collections.Array<string>>>();

		while (sheetEnumerator.MoveNext())
		{
			List<IRow> rowList = ReadAllRows(sheetEnumerator.Current);
			Godot.Collections.Array<Godot.Collections.Array<string>> sheetDataInRowsInStrings = ReadContent(rowList);
			dataInSheetsInRowsInStrings.Add(sheetDataInRowsInStrings);
		}

		//var dataArray = new Godot.Collections.Array<string>(dataInSheetsInRowsInStrings);
		return dataInSheetsInRowsInStrings;
	}


	public Godot.Collections.Array<string> GetSheetNames(string filePath)
	{
		IWorkbook currentBook = ReadWorkbook(filePath);
		Godot.Collections.Array<string> sheetNameArray = ReadSheetNames(currentBook);
		return sheetNameArray;
	}
	private IWorkbook ReadWorkbook(string path)
	{
		IWorkbook book = null;

		try
		{
			FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

			// Try to read workbook as XLSX:
			try
			{
				book = new XSSFWorkbook(fs);
			}
			catch
			{
				book = null;
			}

			// If reading fails, try to read workbook as XLS:
			if (book == null)
			{
				book = new HSSFWorkbook(fs);
			}
		}
		catch (Exception ex)
		{
			//GD.Print(ex);
		}
		return book;
	}

	private List<ISheet> ReadAllSheets(IWorkbook book)
	{
		IEnumerator<ISheet> sheetEnumerator = book.GetEnumerator();
		List<ISheet> sheetList = new List<ISheet>();
		while (sheetEnumerator.MoveNext())
		{
			sheetList.Add(sheetEnumerator.Current);
		}
		return sheetList;
	}

	private List<IRow> ReadAllRows(ISheet sheet)
	{
		IEnumerator row_enumerator = sheet.GetRowEnumerator();
		List<IRow> rows = new List<IRow>();
		while (row_enumerator.MoveNext())
		{
			rows.Add((IRow)row_enumerator.Current);
		}
		return rows;
	}

	private Godot.Collections.Array<Godot.Collections.Array<string>> ReadContent(List<IRow> rows)
	{
		IEnumerator rowEnumerator = rows.GetEnumerator();
		Godot.Collections.Array<Godot.Collections.Array<string>> dataInRows = new Godot.Collections.Array<Godot.Collections.Array<string>>();
		while (rowEnumerator.MoveNext())
		{
			IRow row = (IRow)rowEnumerator.Current;
			IEnumerator<ICell> cellEnumerator = row.GetEnumerator();
			Godot.Collections.Array<string> rowData = new Godot.Collections.Array<string>();
			while (cellEnumerator.MoveNext())
			{
				ICell cell = cellEnumerator.Current;
				string cellData = cell.ToString();
				string cellDataTransformed = cellData.Replace(",", ".");
				rowData.Add(cellDataTransformed);
/* 				CellType cellType = cell.CellType;
				if (cellType == CellType.String)
				{
					string cellData = cell.StringCellValue;
					rowData.Add(cellData);
				}
				else if (cellType == CellType.Numeric)
				{
					double cellData = cell.NumericCellValue;
					rowData.Add(cellData.ToString());
					GD.Print(cellData);
				} */
			}
			dataInRows.Add(rowData);
		}
		return dataInRows;

	}

	private Godot.Collections.Array<string> ReadSheetNames(IWorkbook book)
	{
		int sheetCount = book.NumberOfSheets;
		Godot.Collections.Array<string> sheetNamesArray = new Godot.Collections.Array<string>();
		for (int i = 0; i < sheetCount; i++)
		{
			sheetNamesArray.Add(book.GetSheetName(i));
		}
		return sheetNamesArray;
	}

}


