@tool
class_name Common 

func mod(vec: Vector3) -> Vector3:
	var module: Vector3
	for i in 3:
		if(vec[i] < 0): module[i] = -vec[i]
		else: module[i] = vec[i]
	return module
	
func dist(a: Vector3, b: Vector3) -> float:
	return ((a[0]-b[0])**2+(a[2]-b[2])**2)**0.5

func read_file(path : String) -> String: 
	var f: String = FileAccess.get_file_as_string(path)
	return f
