package components.app
{
	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LoaderInfo;
	import flash.display.NativeMenu;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.text.TextSnapshot;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class Application extends Sprite
	{
		private static var _topLevelAplication:Application;
		private static var _bounds:Rectangle;
		
		public static function get topLevelAplication():Application
		{
			return _topLevelAplication;
		}
		
		private static function staticOnStageResize(event:Event):void
		{
			_bounds.width = _topLevelAplication.stage.stageWidth - 20;
			_bounds.height = _topLevelAplication.stage.stageHeight - 24 - 20;
		}
		
		public static function toogleFullscreen():void
		{
			topLevelAplication.stage.displayState = (topLevelAplication.stage.displayState == StageDisplayState.NORMAL) ? 
				StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
		}
		
		public static function get isFullscreen():Boolean
		{
			return (topLevelAplication.stage.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		public static function get applicationDrawBounds():Rectangle
		{
			return _bounds;
		}
		
		public static function get screenWidth():Number
		{
			return Capabilities.screenResolutionX;
		}
		
		public static function get screenHeight():Number
		{
			return Capabilities.screenResolutionX;
		}
		
		public static function get applicationWidth():Number
		{
			return topLevelAplication.stage.stageWidth;
		}
		
		public static function get applicationHeight():Number
		{
			return topLevelAplication.stage.stageHeight - 24;
		}
		
		////////////////////////END OF STATIC//////////////////////////////////
		
		private var _background:Sprite;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundAlpha:Number = 1;
		private var _statusBar:StatusBar;
		private var _container:Sprite
		
		public function Application()
		{
			super();
			
			_background = new Sprite();
			super.addChild( _background );
			
			_container = new Sprite();
			super.addChild(_container);
			
			_statusBar = new StatusBar();
			super.addChild(_statusBar);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			this.addEventListener(Event.ADDED_TO_STAGE, preInitialize);
			
			_topLevelAplication = this;
			_bounds = new Rectangle( 10, 10, _topLevelAplication.stage.stageWidth - 20, _topLevelAplication.stage.stageHeight - 24 - 20);
			_topLevelAplication.stage.addEventListener( Event.RESIZE, staticOnStageResize );
			
		}
		
		protected function preInitialize(event:Event):void
		{
			drawBackground();
		}
		
		private function onStageResize(event:Event):void
		{
			drawBackground();
			onResize(event)
		}
		
		protected function onResize(event:Event):void
		{
		}
		
		public function get statusBar():StatusBar
		{
			return _statusBar;
		}
		
		public function set statusBar(value:StatusBar):void
		{
			_statusBar = value;
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			drawBackground();
		}
		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			drawBackground();
		}
		
		private function drawBackground():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill( backgroundColor, backgroundAlpha );
			_background.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight - _statusBar.height);
			_background.graphics.endFill();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			switch( type )
			{
				case MouseEvent.CLICK: case MouseEvent.CONTEXT_MENU: case MouseEvent.DOUBLE_CLICK: case MouseEvent.MIDDLE_CLICK:
				case MouseEvent.MIDDLE_MOUSE_DOWN: 	case MouseEvent.MOUSE_DOWN: case MouseEvent.MOUSE_MOVE: case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_OVER: case MouseEvent.MOUSE_UP: case MouseEvent.MOUSE_WHEEL: case MouseEvent.RIGHT_CLICK:
				case MouseEvent.RIGHT_MOUSE_DOWN: case MouseEvent.RIGHT_MOUSE_UP: case MouseEvent.ROLL_OUT: case MouseEvent.ROLL_OVER:
					_background.addEventListener(type, listener, useCapture, priority, useWeakReference);
					break;
				default:
					super.addEventListener(type, listener, useCapture, priority, useWeakReference);
					break;
			}
		}
		
		override public function hasEventListener(type:String):Boolean
		{
			switch( type )
			{
				case MouseEvent.CLICK: case MouseEvent.CONTEXT_MENU: case MouseEvent.DOUBLE_CLICK: case MouseEvent.MIDDLE_CLICK:
				case MouseEvent.MIDDLE_MOUSE_DOWN: 	case MouseEvent.MOUSE_DOWN: case MouseEvent.MOUSE_MOVE: case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_OVER: case MouseEvent.MOUSE_UP: case MouseEvent.MOUSE_WHEEL: case MouseEvent.RIGHT_CLICK:
				case MouseEvent.RIGHT_MOUSE_DOWN: case MouseEvent.RIGHT_MOUSE_UP: case MouseEvent.ROLL_OUT: case MouseEvent.ROLL_OVER:
					return _background.hasEventListener(type);
					break;
				default:
					return super.hasEventListener(type);
					break;
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			switch( type )
			{
				case MouseEvent.CLICK: case MouseEvent.CONTEXT_MENU: case MouseEvent.DOUBLE_CLICK: case MouseEvent.MIDDLE_CLICK:
				case MouseEvent.MIDDLE_MOUSE_DOWN: 	case MouseEvent.MOUSE_DOWN: case MouseEvent.MOUSE_MOVE: case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_OVER: case MouseEvent.MOUSE_UP: case MouseEvent.MOUSE_WHEEL: case MouseEvent.RIGHT_CLICK:
				case MouseEvent.RIGHT_MOUSE_DOWN: case MouseEvent.RIGHT_MOUSE_UP: case MouseEvent.ROLL_OUT: case MouseEvent.ROLL_OVER:
					_background.removeEventListener(type, listener, useCapture);
					break;
				default:
					super.removeEventListener(type, listener, useCapture);
					break;
			}			
		}
		
		override public function willTrigger(type:String):Boolean
		{
			switch( type )
			{
				case MouseEvent.CLICK: case MouseEvent.CONTEXT_MENU: case MouseEvent.DOUBLE_CLICK: case MouseEvent.MIDDLE_CLICK:
				case MouseEvent.MIDDLE_MOUSE_DOWN: 	case MouseEvent.MOUSE_DOWN: case MouseEvent.MOUSE_MOVE: case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_OVER: case MouseEvent.MOUSE_UP: case MouseEvent.MOUSE_WHEEL: case MouseEvent.RIGHT_CLICK:
				case MouseEvent.RIGHT_MOUSE_DOWN: case MouseEvent.RIGHT_MOUSE_UP: case MouseEvent.ROLL_OUT: case MouseEvent.ROLL_OVER:
					return _background.willTrigger(type);
					break;
				default:
					return super.willTrigger(type);
					break;
			}
		}
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return _container.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return _container.removeChild(child);
		}
		
		override public function get numChildren():int
		{
			return _container.numChildren;
		}	
		
		override public function get buttonMode():Boolean
		{
			return _container.buttonMode;
		}
		
		override public function set buttonMode(value:Boolean):void
		{
			_container.buttonMode = value;
		}
		
		override public function get dropTarget():DisplayObject
		{
			
			return _container.dropTarget;
		}
		
		override public function get graphics():Graphics
		{
			
			return _container.graphics;
		}
		
		override public function get hitArea():Sprite
		{
			
			return _container.hitArea;
		}
		
		override public function set hitArea(value:Sprite):void
		{
			
			_container.hitArea = value;
		}
		
		override public function get soundTransform():SoundTransform
		{
			
			return _container.soundTransform;
		}
		
		override public function set soundTransform(sndTransform:SoundTransform):void
		{
			
			_container.soundTransform = sndTransform;
		}
		
		override public function startDrag(lockCenter:Boolean=false, bounds:Rectangle=null):void
		{
			
			_container.startDrag(lockCenter, bounds);
		}
		
		override public function startTouchDrag(touchPointID:int, lockCenter:Boolean=false, bounds:Rectangle=null):void
		{
			
			_container.startTouchDrag(touchPointID, lockCenter, bounds);
		}
		
		override public function stopDrag():void
		{
			
			_container.stopDrag();
		}
		
		override public function stopTouchDrag(touchPointID:int):void
		{
			
			_container.stopTouchDrag(touchPointID);
		}
		
		override public function get useHandCursor():Boolean
		{
			
			return _container.useHandCursor;
		}
		
		override public function set useHandCursor(value:Boolean):void
		{
			
			_container.useHandCursor = value;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			
			return _container.addChildAt(child, index);
		}
		
		override public function areInaccessibleObjectsUnderPoint(point:Point):Boolean
		{
			
			return _container.areInaccessibleObjectsUnderPoint(point);
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			
			return _container.contains(child);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			
			return _container.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			
			return _container.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			
			return _container.getChildIndex(child);
		}
		
		override public function getObjectsUnderPoint(point:Point):Array
		{
			
			return _container.getObjectsUnderPoint(point);
		}
		
		override public function get mouseChildren():Boolean
		{
			
			return _container.mouseChildren;
		}
		
		override public function set mouseChildren(enable:Boolean):void
		{
			
			_container.mouseChildren = enable;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			
			return _container.removeChildAt(index);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			
			_container.setChildIndex(child, index);
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			
			_container.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			
			_container.swapChildrenAt(index1, index2);
		}
		
		override public function get tabChildren():Boolean
		{
			
			return _container.tabChildren;
		}
		
		override public function set tabChildren(enable:Boolean):void
		{
			
			_container.tabChildren = enable;
		}
		
		override public function get textSnapshot():TextSnapshot
		{
			
			return _container.textSnapshot;
		}
		
		override public function get accessibilityImplementation():AccessibilityImplementation
		{
			
			return _container.accessibilityImplementation;
		}
		
		override public function set accessibilityImplementation(value:AccessibilityImplementation):void
		{
			
			_container.accessibilityImplementation = value;
		}
		
		override public function get contextMenu():NativeMenu
		{
			
			return _container.contextMenu;
		}
		
		override public function set contextMenu(cm:NativeMenu):void
		{
			
			_container.contextMenu = cm;
		}
		
		override public function get doubleClickEnabled():Boolean
		{
			
			return _container.doubleClickEnabled;
		}
		
		override public function set doubleClickEnabled(enabled:Boolean):void
		{
			
			_container.doubleClickEnabled = enabled;
		}
		
		override public function get focusRect():Object
		{
			
			return _container.focusRect;
		}
		
		override public function set focusRect(focusRect:Object):void
		{
			
			_container.focusRect = focusRect;
		}
		
		override public function get mouseEnabled():Boolean
		{
			
			return _container.mouseEnabled;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			
			_container.mouseEnabled = enabled;
		}
		
		override public function get needsSoftKeyboard():Boolean
		{
			
			return _container.needsSoftKeyboard;
		}
		
		override public function set needsSoftKeyboard(value:Boolean):void
		{
			
			_container.needsSoftKeyboard = value;
		}
		
		override public function requestSoftKeyboard():Boolean
		{
			
			return _container.requestSoftKeyboard();
		}
		
		override public function get softKeyboardInputAreaOfInterest():Rectangle
		{
			
			return _container.softKeyboardInputAreaOfInterest;
		}
		
		override public function set softKeyboardInputAreaOfInterest(value:Rectangle):void
		{
			
			_container.softKeyboardInputAreaOfInterest = value;
		}
		
		override public function get tabEnabled():Boolean
		{
			
			return _container.tabEnabled;
		}
		
		override public function set tabEnabled(enabled:Boolean):void
		{
			
			_container.tabEnabled = enabled;
		}
		
		override public function get tabIndex():int
		{
			
			return _container.tabIndex;
		}
		
		override public function set tabIndex(index:int):void
		{
			
			_container.tabIndex = index;
		}
		
		override public function get accessibilityProperties():AccessibilityProperties
		{
			
			return _container.accessibilityProperties;
		}
		
		override public function set accessibilityProperties(value:AccessibilityProperties):void
		{
			
			_container.accessibilityProperties = value;
		}
		
		override public function get alpha():Number
		{
			
			return _container.alpha;
		}
		
		override public function set alpha(value:Number):void
		{
			
			_container.alpha = value;
		}
		
		override public function get blendMode():String
		{
			
			return _container.blendMode;
		}
		
		override public function set blendMode(value:String):void
		{
			
			_container.blendMode = value;
		}
		
		override public function set blendShader(value:Shader):void
		{
			
			_container.blendShader = value;
		}
		
		override public function get cacheAsBitmap():Boolean
		{
			
			return _container.cacheAsBitmap;
		}
		
		override public function set cacheAsBitmap(value:Boolean):void
		{
			
			_container.cacheAsBitmap = value;
		}
		
		override public function get cacheAsBitmapMatrix():Matrix
		{
			
			return _container.cacheAsBitmapMatrix;
		}
		
		override public function set cacheAsBitmapMatrix(value:Matrix):void
		{
			
			_container.cacheAsBitmapMatrix = value;
		}
		
		override public function get filters():Array
		{
			
			return _container.filters;
		}
		
		override public function set filters(value:Array):void
		{
			
			_container.filters = value;
		}
		
		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
			
			return _container.getBounds(targetCoordinateSpace);
		}
		
		override public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
		{
			
			return _container.getRect(targetCoordinateSpace);
		}
		
		override public function globalToLocal(point:Point):Point
		{
			
			return _container.globalToLocal(point);
		}
		
		override public function globalToLocal3D(point:Point):Vector3D
		{
			
			return _container.globalToLocal3D(point);
		}
		
		override public function get height():Number
		{
			
			return _container.height;
		}
		
		override public function set height(value:Number):void
		{
			
			_container.height = value;
		}
		
		override public function hitTestObject(obj:DisplayObject):Boolean
		{
			
			return _container.hitTestObject(obj);
		}
		
		override public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean
		{
			
			return _container.hitTestPoint(x, y, shapeFlag);
		}
		
		override public function get loaderInfo():LoaderInfo
		{
			
			return _container.loaderInfo;
		}
		
		override public function local3DToGlobal(point3d:Vector3D):Point
		{
			
			return _container.local3DToGlobal(point3d);
		}
		
		override public function localToGlobal(point:Point):Point
		{
			
			return _container.localToGlobal(point);
		}
		
		override public function get mask():DisplayObject
		{
			
			return _container.mask;
		}
		
		override public function set mask(value:DisplayObject):void
		{
			
			_container.mask = value;
		}
		
		override public function get mouseX():Number
		{
			
			return _container.mouseX;
		}
		
		override public function get mouseY():Number
		{
			
			return _container.mouseY;
		}
		
		override public function get name():String
		{
			
			return _container.name;
		}
		
		override public function set name(value:String):void
		{
			
			_container.name = value;
		}
		
		override public function get opaqueBackground():Object
		{
			
			return _container.opaqueBackground;
		}
		
		override public function set opaqueBackground(value:Object):void
		{
			
			_container.opaqueBackground = value;
		}
		
		override public function get parent():DisplayObjectContainer
		{
			
			return _container.parent;
		}
		
		override public function get root():DisplayObject
		{
			
			return _container.root;
		}
		
		override public function get rotation():Number
		{
			
			return _container.rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			
			_container.rotation = value;
		}
		
		override public function get rotationX():Number
		{
			
			return _container.rotationX;
		}
		
		override public function set rotationX(value:Number):void
		{
			
			_container.rotationX = value;
		}
		
		override public function get rotationY():Number
		{
			
			return _container.rotationY;
		}
		
		override public function set rotationY(value:Number):void
		{
			
			_container.rotationY = value;
		}
		
		override public function get rotationZ():Number
		{
			
			return _container.rotationZ;
		}
		
		override public function set rotationZ(value:Number):void
		{
			
			_container.rotationZ = value;
		}
		
		override public function get scale9Grid():Rectangle
		{
			
			return _container.scale9Grid;
		}
		
		override public function set scale9Grid(innerRectangle:Rectangle):void
		{
			
			_container.scale9Grid = innerRectangle;
		}
		
		override public function get scaleX():Number
		{
			
			return _container.scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			
			_container.scaleX = value;
		}
		
		override public function get scaleY():Number
		{
			
			return _container.scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			
			_container.scaleY = value;
		}
		
		override public function get scaleZ():Number
		{
			
			return _container.scaleZ;
		}
		
		override public function set scaleZ(value:Number):void
		{
			
			_container.scaleZ = value;
		}
		
		override public function get scrollRect():Rectangle
		{
			
			return _container.scrollRect;
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			
			_container.scrollRect = value;
		}
		
		override public function get stage():Stage
		{
			
			return _container.stage;
		}
		
		override public function get transform():Transform
		{
			
			return _container.transform;
		}
		
		override public function set transform(value:Transform):void
		{
			
			_container.transform = value;
		}
		
		override public function get visible():Boolean
		{
			
			return _container.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			
			_container.visible = value;
		}
		
		override public function get width():Number
		{
			
			return _container.width;
		}
		
		override public function set width(value:Number):void
		{
			
			_container.width = value;
		}
		
		override public function get x():Number
		{
			
			return _container.x;
		}
		
		override public function set x(value:Number):void
		{
			
			_container.x = value;
		}
		
		override public function get y():Number
		{
			
			return _container.y;
		}
		
		override public function set y(value:Number):void
		{
			_container.y = value;
		}
		
		override public function get z():Number
		{
			return _container.z;
		}
		
		override public function set z(value:Number):void
		{
			_container.z = value;
		}		
	}
}