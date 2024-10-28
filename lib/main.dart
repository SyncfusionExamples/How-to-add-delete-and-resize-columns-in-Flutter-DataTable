import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

Map<String, double> columnWidths = {
  'id': double.nan,
  'name': double.nan,
  'designation': double.nan,
  'salary': double.nan
};

class _MyHomePageState extends State<MyHomePage> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  List<GridColumn> columns = [];

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(
      employees: employees,
    );
    columns = employeeDataSource.columns;
  }

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

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000, 'IT'),
      Employee(10002, 'Kathryn', 'Manager', 30000, 'HR'),
      Employee(10003, 'Lara', 'Developer', 15000, 'IT'),
      Employee(10004, 'Michael', 'Designer', 15000, 'Design'),
      Employee(10005, 'Martin', 'Developer', 15000, 'IT'),
      Employee(10006, 'Newberry', 'Developer', 15000, 'IT'),
      Employee(10007, 'Balnc', 'Developer', 15000, 'IT'),
      Employee(10008, 'Perry', 'Developer', 15000, 'IT'),
      Employee(10009, 'Gable', 'Developer', 15000, 'IT'),
      Employee(10010, 'Grimes', 'Developer', 15000, 'IT'),
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary, this.team);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;

  /// team of the employee.
  final String team;

  /// Overrides the indexing operator to provide access to specific properties of the [Employee] class.
  operator [](Object? value) {
    if (value == 'id') {
      return id;
    } else if (value == 'name') {
      return name;
    } else if (value == 'designation') {
      return designation;
    } else if (value == 'salary') {
      return salary;
    } else if (value == 'team') {
      return team;
    } else {
      throw ArgumentError('Invalid property: $value');
    }
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  final List<GridColumn> columns = [
    GridColumn(
        width: columnWidths['id']!,
        columnName: 'id',
        label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text('ID'))),
    GridColumn(
        width: columnWidths['name']!,
        columnName: 'name',
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Name'))),
    GridColumn(
        width: columnWidths['designation']!,
        columnName: 'designation',
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Designation'))),
    GridColumn(
        width: columnWidths['salary']!,
        columnName: 'salary',
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Salary'))),
  ];

  List<Employee> employees;

  EmployeeDataSource({required this.employees}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _employeeData = [];

  // Update rows based on the current number of columns.
  void _buildDataGridRows() {
    _employeeData = employees.map<DataGridRow>((employee) {
      return DataGridRow(
          cells: columns.map<DataGridCell>((column) {
        return DataGridCell(
          columnName: column.columnName,
          value: employee[column.columnName],
        );
      }).toList());
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}
