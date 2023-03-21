function transform(line) {
    var values = line.split(',');

    var obj = new Object();
    obj.user = values[0];
    obj.age = values[1];
    var jsonString = JSON.stringify(obj);

    return jsonString;
    }