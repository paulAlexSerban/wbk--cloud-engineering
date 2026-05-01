from tornado import web, ioloop
import json, os, uuid

class BasicRequestHandler(web.RequestHandler):
    def get(self):
        self.render('index.html')

class ListRequestHandler(web.RequestHandler):
    def get(self):
        fh = open('list.json', 'r')
        animals_json = fh.read()
        animals = json.loads(animals_json)
        fh.close()
        self.write(json.dumps(animals))
        self.set_header('Content-Type', 'application/json')

    def post(self):
        animal = self.get_argument('name')
        with open('list.json', 'r+') as fh:
            # Read and parse the existing JSON data
            animals_json = fh.read()
            animals = json.loads(animals_json)
            
            # Add the new animal
            animal_obj = {
                'id': len(animals) + 1,
                'name': animal
            }
            animals.append(animal_obj)
            
            # Move the file pointer to the beginning and truncate the file
            fh.seek(0)
            fh.truncate()
            
            # Write the updated JSON data back to the file
            fh.write(json.dumps(animals))
        
        self.write(json.dumps(animals))
        self.set_header('Content-Type', 'application/json')

        
class QueryParamRequestHandler(web.RequestHandler):
    def get(self):
        number = self.get_argument('number')
        numberIsInt = number.isdigit()
        if numberIsInt:
            isEven = int(number) % 2 == 0
            self.write(f"Your number is {number} and it is {'even' if isEven else 'odd'}")
        else:
            self.write("Invalid input")
            
class ResourceRequestHandler(web.RequestHandler):
    def get(self, studentName, courseId):
        self.write(f"Welcome {studentName}! Your course id is {courseId}")

class JSONRequestHandler(web.RequestHandler):
    def get(self):
        fh = open('list.json', 'r')
        animals = fh.read().splitlines()
        fh.close()
        self.write(json.dumps(animals))

    def post(self):
        animal = self.get_argument('name')
        fh = open('list.json', 'a')
        # push the new animal to the list
        fh.write(f'\n{animal}')
        fh.close()
        self.write(f"Added {animal}")

class ImageHandler(web.RequestHandler):
    def initialize(self, path):
        self.path = path

    def get(self, image_name):
        image_path = os.path.join(self.path, image_name)
        if not os.path.exists(image_path):
            self.set_status(404)
            self.write("Image not found")
            return

        with open(image_path, 'rb') as f:
            self.write(f.read())
        self.set_header('Content-Type', 'image/png')

    # def post(self, image_name):
    #     files = self.request.files
    #     print(files)
    #     if not files:  # Check if no files were uploaded
    #         self.set_status(400)
    #         self.write("No file uploaded")
    #         return

    #     uploaded_files = []  # Keep track of uploaded file names
    #     for file in files:
    #         file_path = os.path.join(self.path, file.filename)
    #         with open(file_path, 'wb') as fh:
    #             fh.write(file.body)
    #         uploaded_files.append(file.filename)

    #     # Respond with details of uploaded files
    #     self.write({
    #         "message": "Files uploaded successfully",
    #         "files": [f"http://localhost:5000/img/{name}" for name in uploaded_files]
    #     })
    #     self.set_header("Content-Type", "application/json")

class UploadHandler(web.RequestHandler):
    def post(self):
        files = self.request.files["imgFile"]
        print(files)
        if not files:  # Check if no files were uploaded
            self.set_status(400)
            self.write("No file uploaded")
            return

        uploaded_files = []  # Keep track of uploaded file names
        for file in files:
            file_path = os.path.join('img', file.filename)
            with open(file_path, 'wb') as fh:
                fh.write(file.body)
            uploaded_files.append(file.filename)

        # Respond with details of uploaded files
        self.write({
            "message": "Files uploaded successfully",
            "files": [f"http://localhost:5000/img/{name}" for name in uploaded_files]
        })
        self.set_header("Content-Type", "application/json")


if __name__ == '__main__':
    app = web.Application([
        (r"/", BasicRequestHandler),
        (r"/animals", ListRequestHandler),
        (r"/query", QueryParamRequestHandler),
        (r"/students/([a-z]+)/([0-9]+)", ResourceRequestHandler),
        (r"/json", JSONRequestHandler),
        (r"/upload", UploadHandler),
        (r"/img/(.*)", ImageHandler, {'path': 'img'}),
    ])
    port = 5000
    app.listen(port)
    print(f"I'm listening on port {port}")
    ioloop.IOLoop.current().start()