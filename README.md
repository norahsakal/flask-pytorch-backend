# flask-pytorch-backend

### 1. Create the frontend
### App.js in this repo is a basic start where you can upload an image in the frontend that is sent to the Flask backend

Following steps describes how to create a very simple frontend using ReactJS
- Create a new app by following https://github.com/facebook/create-react-app

```
npx create-react-app my-app
cd my-app
npm start
```

#### 1.1. Create a button for choosing an image

`<input type="file" name="file" />`


#### 1.2. Create a button that is sending the image to the backend

`<input type="submit" />`


#### 1.3. Define the state
```
constructor() {
  super()
  this.state = {
  }
}
```


#### 1.4. Create a function for previewing the uploaded image
```  
generatePreviewImgUrl(file, callback) 
  {
  const reader = new FileReader()
  const url = reader.readAsDataURL(file)
  reader.onloadend = e => callback(reader.result)
   }
```


#### 1.5. Add a field below the buttons for previewing the chosen image
```
{ this.state.previewImageUrl &&
          <img height={this.state.imageHeight} alt="" src={this.state.previewImageUrl} />
          }
```


#### 1.6. Update the state with `previewImgUrl: false` before an image is chosen and desired height of the image preview `imgHeight: 200`

<pre>
  constructor() {
    super()
    this.state = {
      <b>previewImgUrl: false,</b>
      <b>imgHeight: 200</b>
    }
    this.generatePreviewImgUrl = this.generatePreviewImgUrl.bind(this)
  }
</pre>


#### 1.7. Create an event handler that gets triggered when the image is chosen
<pre>
    handleChange(event) {
      const file = event.target.files[0]
      
      // If the image upload is cancelled
      if (!file) {
        return
      }

      this.setState({imgFile: file})
      console.log("Into handleChange")
      this.generatePreviewImgUrl(file, previewImgUrl => {
            this.setState({
              <b>previewImgUrl</b>
            })
          })
    }
</pre>


#### 1.8. Update the constructor with binding handleChange to this
`this.handleChange = this.handleChange.bind(this)`


#### 1.9. Update the button to trigger event handler
`<input type="file" name="file" onChange={this.handleChange} /> `


#### 1.10. Install and import axios for image upload

`npm install axios`

`import axios from 'axios';`


#### 1.11. Create a function that sends the chosen image to the backend
```
  uploadHandler(e) {
    var self = this;
    const formData = new FormData()
    formData.append('file', this.state.imgFile, 'img.png')
    
    axios.post('http://localhost:5000/upload', formData)
    .then(function(response, data) {
            data = response.data;
            self.setState({imagePrediction:data})
        })
    
  }
```


#### 1.12. Update the constructor with binding uploadHandler to this
`this.uploadHandler = this.uploadHandler.bind(this)` 


#### 1.13. Update the submit button to trigger uploadHandler
`<input type="submit" onClick={this.uploadHandler} />`


#### 1.14. Update the state with the response from the backend
<pre>
   this.state = {
      previewImgUrl: false,
      imgHeight: 200,
      <b>imagePrediction: ""</b>,
    }
</pre>


#### 1.15. Update the event handler to reset the predicted image class when a new image is uploaded
<pre>
this.setState({
              previewImgUrl,
              <b>imagePrediction:""</b>
            })
          })
</pre>


#### 1.16. Add a hidden text that appears once the model predicted the image class
```
{ this.state.imagePrediction &&
            <p>The prediction is: {this.state.imagePrediction}
            </p>
          }
```


#### 1.17. **Optional:** add a function that calculates the time it takes for the model to predict the image class
<pre>
<b>var t0 = performance.now();</b>
    axios.post('http://127.0.0.1:5000/upload', formData)
    .then(function(response, data) {
            data = response.data;
            self.setState({imagePrediction:data})
            <b>var t1 = performance.now();</b>
            <b>console.log("The time it took to predict the image " + (t1 - t0) + " milliseconds.")</b>
        })
    }
</pre>
### 2. Create the backend
### app.py in this repo is a basic start of a Flask backend with a classification model that predicts the class of the uploaded image

Following steps describes how to create a very simple backend using Flask using http://flask.pocoo.org/docs/1.0/quickstart/ and http://flask.pocoo.org/docs/0.12/patterns/fileuploads/

#### 2.1. Create a new file and import the Flask class 

`pip install flask`

`from flask import Flask`


#### 2.2. Create an instance of the class

`app = Flask(__name__)`


#### 2.3. Create route() decorator
```@app.route('/')
def hello_world():
    return 'Hello, World!'
```


#### 2.4. Create __main__ function
```
if __name__ == "__main__":
app.run(debug=True)
```


#### 2.5. Test run the app, it usually appears in 5000

`python app.py`


#### 2.6. Update the imports
```
import os
from flask import Flask, request, redirect, url_for
from werkzeug.utils import secure_filename
from flask_cors import CORS

```


#### 2.7. Add path for uploaded files and choose allowed  file extensions
```
UPLOAD_FOLDER = 'data/uploads/'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
``` 


#### 2.8. Create a function that checks if the uploaded image extension is valid
```
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
```


#### 2.9. Create a function that receives the image from the frontend
```
def upload_file():
    if request.method == 'POST':
        print("request data", request.data)
        print("request files", request.files)
        # check if the post request has the file part
        if 'file' not in request.files:
            return "No file part"
        file = request.files['file']

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            
            predicted_image_class, cropped_img = predict_image_class(UPLOAD_FOLDER)

            img_color_name = get_color(cropped_img)
            #predict_img(UPLOAD_FOLDER+filename)
            print("predicted_image_class", predicted_image_class)
```


#### 2.10. Create a function that predicts the uploaded image
```
@app.route('/upload', methods=['GET', 'POST'])
def predict_img(img_path):

    # Available model archtectures = 
    #'alexnet','densenet121', 'densenet169', 'densenet201', 'densenet161','resnet18', 
    #'resnet34', 'resnet50', 'resnet101', 'resnet152','inceptionv3','squeezenet1_0', 'squeezenet1_1',
    #'vgg11', 'vgg11_bn', 'vgg13', 'vgg13_bn', 'vgg16', 'vgg16_bn','vgg19_bn', 'vgg19'
    

    # Choose which model achrictecture to use from list above
    architecture = models.squeezenet1_0(pretrained=True)
    architecture.eval()

    # Normalization according to https://pytorch.org/docs/0.2.0/torchvision/transforms.html#torchvision.transforms.Normalize
    # Example seen at https://github.com/pytorch/examples/blob/42e5b996718797e45c46a25c55b031e6768f8440/imagenet/main.py#L89-L101
    normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                         std=[0.229, 0.224, 0.225])
        
    # Preprocessing according to https://pytorch.org/tutorials/beginner/data_loading_tutorial.html
    # Example seen at https://github.com/pytorch/examples/blob/42e5b996718797e45c46a25c55b031e6768f8440/imagenet/main.py#L89-L101

    preprocess = transforms.Compose([
       transforms.Resize(256),
       transforms.CenterCrop(224),
       transforms.ToTensor(),
       normalize
    ])

    # Path to uploaded image
    path_img = img_path

    # Read uploaded image
    read_img = Image.open(path_img)

    # Convert image to RGB if it is a .png
    if path_img.endswith('.png'):
        read_img = read_img.convert('RGB')

    img_tensor = preprocess(read_img)
    img_tensor.unsqueeze_(0)
    img_variable = Variable(img_tensor)

    # Predict the image
    outputs = architecture(img_variable)

    # Couple the ImageNet label to the predicted class
    labels = {int(key):value for (key, value)
              in json_classes.items()}
    print("\n Answer: ",labels[outputs.data.numpy().argmax()])


    return labels[outputs.data.numpy().argmax()]
```


#### 2.11. Import Pytorch related imports

`pip install torchvision`

```
from torchvision import models, transforms
from torch.autograd import Variable
import torchvision.models as models
```


#### 2.12. Add a json with ImageNet classes
```
import json
import requests
```

```
class_labels = 'imagenet_classes.json'
with open('imagenet_classes.json', 'r') as fr:
    json_classes = json.loads(fr.read())
```


#### 2.13. Install and add PIL

`pip install pillow`

`from PIL import Image`


## Done, that's all!
