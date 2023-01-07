package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class Utils 
	{
		public static function markReferencePoint(object:DisplayObjectContainer, color:uint = 0xFFFFFF, crossAngle:Number = 45):void
		{
			var mark:Shape = new Shape();
			mark.graphics.lineStyle(1, color);
			mark.graphics.moveTo(-5, -5);
			mark.graphics.lineTo(5, 5);
			mark.graphics.moveTo(-5, 5);
			mark.graphics.lineTo(5, -5);
			
			var tranformMatrix:Matrix = new Matrix();
			tranformMatrix.rotate( (crossAngle-45) * 180/Math.PI );
			mark.transform.matrix = tranformMatrix; 
			
			object.addChild(mark);
		}
		
		public static function removeAllChildren( container:DisplayObjectContainer ):void
		{
			while( container.numChildren > 0 )
			{
				container.removeChildAt(0);
			}
		}
		
		public static function distance( x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			var deltaX:Number = x1 - x0;
			var deltaY:Number = y1 - y0;
			return Math.sqrt( deltaX*deltaX + deltaY*deltaY );
		}
		
		public static function distanceToObj( obj:DisplayObject, x:Number, y:Number):Number
		{
			var deltaX:Number = x - obj.x;
			var deltaY:Number = y - obj.y;
			return Math.sqrt( deltaX*deltaX + deltaY*deltaY );
		}

		public static function alignLeft(alignTo:DisplayObject, objToAlign:DisplayObject, padding:Number = 0):void 
		{
			objToAlign.x = alignTo.x + padding;
		}

		public static function alignRight(alignTo:DisplayObject, objToAlign:DisplayObject, padding:Number = 0):void 
		{
			objToAlign.x = alignTo.x + alignTo.width - objToAlign.width - padding;
		}

		public static function alignTop(alignTo:DisplayObject, objToAlign:DisplayObject, padding:Number = 0):void 
		{
			objToAlign.y = alignTo.y - objToAlign.height - padding;
		}

		public static function alignBottom(alignTo:DisplayObject, objToAlign:DisplayObject, padding:Number = 0):void 
		{
			objToAlign.y = alignTo.y + alignTo.height + padding;
		}

		public static function centerObjectToStage(obj:DisplayObject):void
		{
			obj.x = obj.stage.stageWidth / 2 - obj.width / 2;
			obj.y = obj.stage.stageHeight / 2 - obj.height / 2;
		}
	}
}