package field.electric
{
	import components.app.Application;
	
	import field.Unit;
	import field.ui.vector.VectorFieldObject;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	
	import utils.Utils;
	
	public class ElectricField extends Sprite
	{
		public static const E0:Number = 8.854187817620E-12; // unit: F/m --> Farad per meter	
		public static const KE:Number = 1/(4*Math.PI * E0); // unit: N m^2 / C^2 --> Newton meter square per square coulomb
		public static var unitPerPixel:Number = Unit.MILI;
		
		public static function potencial( q:Number, r:Number ):Number
		{
			r /= unitPerPixel;
			
			return KE*q/r;
		}
		
		public static function fieldVector( q:Number, deltaX:Number, deltaY:Number):Vector3D
		{
			deltaX /= unitPerPixel;
			deltaY /= unitPerPixel;
			
			var r:Number = Math.sqrt( deltaX*deltaX + deltaY*deltaY );
			
			return new Vector3D( 
				KE * q * deltaX / Math.pow( r, 3),
				KE * q * deltaY / Math.pow( r, 3)
			);			
		}
		
		//////////// END OF STATIC ////////////
		
		
		private var _vectorField:Sprite;
		private var _fieldLines:Shape;
		private var _chargeLayer:Sprite;
		
		public function ElectricField()
		{
			super();
			
			_fieldLines = new Shape();
			_fieldLines.graphics.lineStyle(1,0xFFFFFF);
			addChild(_fieldLines);
			
			_vectorField = new Sprite();
			addChild( _vectorField );
			
			_chargeLayer = new Sprite();
			addChild( _chargeLayer );
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function clean():void
		{
			//_vectorField.graphics.clear();
			_fieldLines.graphics.clear();
			_fieldLines.graphics.lineStyle(1,0xFFFFFF);
		}
		
		protected function onAdded(event:Event):void
		{
			Application.topLevelAplication.addEventListener( MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			trace(event.localX,event.localY);
			drawFieldLine(event.localX,event.localY);
		}
		
		protected function drawFieldLines():void
		{
			
		}
		
		protected function drawFieldLine( x:Number, y:Number ):void
		{
			drawFromPointToCharge(x,y,1);
			drawFromPointToCharge(x,y,-1);
		}
		
		protected function drawFromPointToCharge(startX:Number,startY:Number,direction:int=1):void
		{
			var ds:Number = 6.5;
			var controlDistance:Number = 0.9*Math.sqrt( 
				Math.pow(Application.screenWidth,2) +
				Math.pow(Application.screenHeight,2)
			);
			
			var drawX:Number;
			var drawY:Number;
			var unitE:Vector3D;
			
			for( var i:uint = 0; isDistanceToChargesInBetween( startX, startY, 6, controlDistance) ; i++)
			{			
				unitE = this.getFieldAt( startX, startY ); 
				unitE.normalize();
				if( direction < 0 )
					unitE.negate();
				
				drawX = startX + ds*unitE.x;
				drawY = startY + ds*unitE.y;
				
				_fieldLines.graphics.moveTo(startX, startY);
				_fieldLines.graphics.lineTo(drawX, drawY);
				
				startX = drawX;
				startY = drawY;
				
				if( i == int( controlDistance/ds + 1 ) ) break;
			}
		}
		
		protected function isDistanceToChargesInBetween(x:Number, y:Number, min:Number, max:Number):Boolean
		{
			var result:Boolean = true;
			var distance:Number;
			
			for(var i:uint = 0; i < numCharges; i++)
			{
				distance = Utils.distanceToObj( getChargeAt(i), x, y);
				result &&= (distance > min && distance < max)
			}
			
			return result;
		}
		
		protected function drawObjectField(drawClass:Class, x:Number, y:Number):void
		{
			var vectorObj:VectorFieldObject = new drawClass() as VectorFieldObject;
			vectorObj.vector = getFieldAt( x, y );
			vectorObj.x = x;
			vectorObj.y = y;
			_vectorField.addChild( vectorObj );
		}
		
		protected function drawTrigonalGrid(drawClass:Class):void
		{
			var hS:Number = 50;
			var vS:Number = hS * Math.sqrt(3)/2;
			var padding:Number = 20; 
			
			for( var j:uint = 0; j < (Application.screenHeight-padding)/vS; j++)
			{
				for( var i:uint = 0; i < (Application.screenWidth-padding)/hS; i++)
				{
					var x:Number = (i % 2 == 0) ? padding + i*vS : padding + (i+0.5)*vS;
					var y:Number = padding + j*hS;
					
					drawObjectField(drawClass, x, y);
				}
			}
		}
		
		protected function drawSquaredGrid(drawClass:Class):void
		{
			var hS:Number = 50;
			var vS:Number = 50;
			var padding:Number = 20; 
			
			for( var j:uint = 0; j < (Application.screenHeight-padding)/vS; j++)
			{
				for( var i:uint = 0; i < (Application.screenWidth-padding)/hS; i++)
				{
					var x:Number = padding + i*vS;
					var y:Number = padding + j*hS;
					
					drawObjectField(drawClass, x, y);
				}
			}
		}
		
		public function createCharge( coulomb:Number, x:Number, y:Number):Charge
		{
			var charge:Charge = new Charge(coulomb);
			charge.x = x;
			charge.y = y;
			charge.addEventListener("chargeMove", onChargeMove);
			return addCharge( charge );
		}
		
		protected function onChargeMove(event:Event):void
		{
			clean();
			trace("chargemove x="+event.currentTarget.x+" y="+event.currentTarget.y);
		}
		
		public function getFieldAt( x:Number, y:Number):Vector3D
		{
			var result:Vector3D = new Vector3D();
			
			for (var i:int = 0; i < numCharges; i++) 
			{
				var charge:Charge = getChargeAt(i);
				result.incrementBy( 
					ElectricField.fieldVector( charge.coulomb, x - charge.x, y - charge.y)
				);
			}
			return result;
		}
		
		public function getPotencialAt( x:Number, y:Number):Number
		{
			var result:Number = 0;
			var distance:Number;
			
			for (var i:int = 0; i < numCharges; i++) 
			{
				var charge:Charge = getChargeAt(i);
				distance = Math.sqrt( Math.pow( x - charge.x ,2) + Math.pow( y - charge.y ,2) );
				result += ElectricField.potencial(charge.coulomb, distance );
			}
			
			return result;
		}
		
		public function addCharge(child:Charge):Charge
		{
			return _chargeLayer.addChild( child ) as Charge;
		}
		
		public function addChargeAt( child:Charge, index:int):Charge
		{
			return _chargeLayer.addChildAt( child, index ) as Charge;
		}
		
		public function getChargeAt( index:int ):Charge
		{
			return _chargeLayer.getChildAt( index ) as Charge;
		}
		
		public function getChargeIndex( charge:Charge ):int
		{
			return _chargeLayer.getChildIndex( charge );
		}
		
		public function removeAllCharges():void
		{
			Utils.removeAllChildren( _chargeLayer );
		}
		
		public function removeCharge( charge:Charge ):Charge
		{
			return _chargeLayer.removeChild( charge ) as Charge;
		}
		
		public function removeChargeAt( index:int ):Charge
		{
			return _chargeLayer.removeChildAt( index ) as Charge;
		}
		
		public function get numCharges():int
		{
			return _chargeLayer.numChildren;
		}
	}
}