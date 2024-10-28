# How to add, delete and resize columns in Flutter DataTable?.

In this article, we will show you how to add, delete and resize columns in [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with the necessary properties. Maintain the column width collection at the application level and adjust widths using the [SfDataGrid.onColumnResizeUpdate](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/onColumnResizeUpdate.html) callback. In this callback, identify the resized column, update its width, and replace the old column in the columns list. Update the columnWidths collection when adding or removing columns. After modifying columns, rebuild the rows to reflect the changes.

```dart
Map<String, double> columnWidths = {
  'id': double.nan,
  'name': double.nan,
  'designation': double.nan,
  'salary': double.nan
};

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter DataGrid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                // Set the width of the new column.
                columnWidths['team'] = double.nan;
                columns.add(
                  GridColumn(
                      width: columnWidths['team']!,
                      columnName: 'team',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: const Text('Team'))),
                );

                employeeDataSource._buildDataGridRows();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                columns.removeLast();
                // Remove the width of the deleted column.
                columnWidths.remove(columnWidths.keys.last);
                employeeDataSource._buildDataGridRows();
              });
            },
          ),
        ],
      ),
      body: SfDataGrid(
        source: employeeDataSource,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowColumnsResizing: true,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            int index = columns.indexOf(columns.firstWhere(
                (element) => element.columnName == details.column.columnName));
            columns[index] = GridColumn(
                columnName: details.column.columnName,
                width: details.width,
                label: details.column.label);
          });
          return true;
        },
        columns: columns,
      ),
    );
  }
```

You can download this example in [GitHub](https://github.com/SyncfusionExamples/How-to-add-delete-and-resize-columns-in-Flutter-DataTable).