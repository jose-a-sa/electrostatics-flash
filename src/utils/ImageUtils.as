package utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public class ImageUtils
	{

		public function ImageUtils()
		{
			/*
			Every single time you use the resizeNumbers() make sure that you create a new variable to the returned vaule (an Array) because if you use it this way will not work:
			
			target.width = resizeNumbers(target,maxWidth,maxHeight,scaleMode).width;
			target.height = resizeNumbers(target,maxWidth,maxHeight,scaleMode).height;
			
			This way it will not work because if you assign the resized value to the width or the height of the object the function will use the current width and height of an object and you will get a completely diferent value. To circumvent this problem you should use it like this:
			
			//First way:
			
			var newSizes:Array = resizeNumbers(target,maxWidth,maxHeight,scaleMode);
			
			target.width = newSizes.width;
			target.height = newSizes.height;
			
			//Second way:
			
			//ONE OF TWO WAYS FOR USING A OBJECT//
			var obj:Object = {width:target.width, height:target.height}; 
			//OR//
			var obj:Object = new Object();
			obj.width = target.width;
			obj.height = target.height;
			
			
			target.width = resizeNumbers(obj,maxWidth,maxHeight,scaleMode).width;
			target.height = resizeNumbers(obj,maxWidth,maxHeight,scaleMode).height;
			
			
			//Third way(less recomended):
			//IF YOU NOW WHAT ARE THE WIDTH AND HEIGHT OF THE TARGET, LETS SAY FOR EXAMPLE 500 AND 400//
			
			target.width = resizeNumbers({width:500, height:400},maxWidth,maxHeight,scaleMode).width;
			target.height = resizeNumbers({width:500, height:400},maxWidth,maxHeight,scaleMode).height;
			
			*/
		}

		public static function renderToBitmap(obj:DisplayObject, maxWidth:Number, maxHeight:Number, scaleMode:String="fit"):Bitmap
		{
			var pre_bm:Bitmap = Bitmap(obj);

			var newSizes:Object = resizeNumbers(pre_bm, maxWidth, maxHeight, scaleMode);

			pre_bm.width = newSizes.width;
			pre_bm.height = newSizes.height;

			pre_bm.smoothing = true;

			return pre_bm;
		}

		public static function resize(obj:DisplayObject, maxWidth:Number, maxHeight:Number, scaleMode:String="fit"):void
		{
			var newSizes:Object = resizeNumbers(obj,maxWidth,maxHeight,scaleMode);
			obj.width = newSizes.width;
			obj.height = newSizes.height;
		}
		
		public static function resizeNumbers(obj:Object,maxWidth:Number,maxHeight:Number,scaleMode:String="fit"):Object
		{
			var originalW:Number = obj.width;
			var originalH:Number = obj.height;
			var scaleX:Number = maxWidth/originalW;
			var scaleY:Number = maxHeight/originalH;
			
			switch (scaleMode)
			{
				case "fit" :
					(scaleX < scaleY) ? scaleY=scaleX : scaleX=scaleY;
					break;
				case "fill" :
					(scaleX > scaleY) ? scaleY=scaleX : scaleX=scaleY;
					break;
			}
			
			return {width: originalW*scaleX, height: originalH*scaleY}
		}
	}
}