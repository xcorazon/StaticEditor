package  pr1{
	import pr1.Shapes.Segment;
	import pr1.forces.*;
	import pr1.CoordinateTransformation;
	import flash.geom.Point;
	import pr1.razmers.*;
	import pr1.opora.*;
	
	public class OutDataCreator {

		private var outData:XML;
		
		public function OutDataCreator() {
			// constructor code
			clearLists();
			
			trace( outData.toString());
		}
		
		public function clearLists(){
			outData = 
			<WorkData>
				<pointsList>
				</pointsList>
				<segmentsList>
				</segmentsList>
				<cForcesList>
				</cForcesList>
				<drForcesList>
				</drForcesList>
				<dtForcesList>
				</dtForcesList>
				<momentsList>
				</momentsList>
				<lDimensionsList>
				</lDimensionsList>
				<anglesList>
				</anglesList>
				<jointsList>
				</jointsList>
			</WorkData>;
		}
		
		public function addPointsListFromSegments(segments:Array){
			for each (var seg:Segment in segments){
				var newElement:XML = <point/>;
				newElement.@id = seg.firstPointNumber;
				newElement.@x = seg.firstDecartCoord.x.toFixed(0);
				newElement.@y = seg.firstDecartCoord.y.toFixed(0);
				trace(outData.pointsList.point.(@id == newElement.@id).@id);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
				
				newElement = <point/>;
				newElement.@id = seg.secondPointNumber;
				newElement.@x = seg.secondDecartCoord.x.toFixed(0);
				newElement.@y = seg.secondDecartCoord.y.toFixed(0);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
			}
			trace(outData.toString());
		}
		public function addPointsListFromConcentratedForces(forces:Array){
			for each (var f:ConcentratedForce in forces){
				var newElement:XML = <point/>;
				newElement.@id = f.forceNumber;
				var p:Point = CoordinateTransformation.screenToLocal( new Point(f.x, f.y), new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				trace(outData.pointsList.point.(@id == newElement.@id).@id);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
			}
			trace(outData.toString());
		}
		public function addPointsListFromDistributedForcesR(forces:Array){
			for each (var f:DistributedForceR in forces){
				var newElement:XML = <point/>;
				newElement.@id = f.forceNumber1;
				var p:Point = CoordinateTransformation.screenToLocal(f.firstScreenCoord, new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
				
				newElement = <point/>;
				newElement.@id = f.forceNumber2;
				p = CoordinateTransformation.screenToLocal(f.secondScreenCoord, new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
			}
			trace(outData.toString());
		}
		public function addPointsListFromDistributedForcesT(forces:Array){
			for each (var f:DistributedForceT in forces){
				var newElement:XML = <point/>
				newElement.@id = f.forceNumber1;
				var p:Point = CoordinateTransformation.screenToLocal(f.firstScreenCoord, new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
				
				newElement = <point/>;
				newElement.@id = f.forceNumber2;
				p = CoordinateTransformation.screenToLocal(f.secondScreenCoord, new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
			}
			trace(outData.toString());
		}
		public function addPointsListFromJoints(joints:Array){
			for each (var f in joints){
				var newElement:XML = <point/>;
				newElement.@id = f.pointNumber;
				var p:Point = CoordinateTransformation.screenToLocal( new Point(f.x, f.y), new Point(0,600), 0);
				newElement.@x = p.x.toFixed(0);
				newElement.@y = p.y.toFixed(0);
				trace(outData.pointsList.point.(@id == newElement.@id).@id);
				if(outData.pointsList.point.(@id == newElement.@id).@id != newElement.@id){
					outData.pointsList.appendChild(newElement);
				}
			}
		}
		public function createSegmentsList(segments:Array, pForces:Array, drForces:Array,
										   dtForces:Array, joints:Array){
			for each (var seg:Segment in segments){
				var segment:XML =<segment/>;
				var point:XML = <point>{seg.firstPointNumber}</point>;
				segment.appendChild(point);
				point = <point>{seg.secondPointNumber}</point>;
				segment.appendChild(point);
				for each ( var f:ConcentratedForce in pForces){
					if( f.segment == seg){
						point = <point>{f.forceNumber}</point>;
						segment.appendChild(point);
					}
				}
			
				for each ( var dr:DistributedForceR in drForces){
					if( dr.segment == seg){
						point = <point>{dr.forceNumber1}</point>;
						segment.appendChild(point);
						point = <point>{dr.forceNumber2}</point>;
						segment.appendChild(point);
					}
				}
			
				for each ( var dt:DistributedForceT in dtForces){
					if( dt.segment == seg){
						point = <point>{dt.forceNumber1}</point>;
						segment.appendChild(point);
						point = <point>{dt.forceNumber2}</point>;
						segment.appendChild(point);
					}
				}
			
				for each (var joint in joints){
					if(joint.segment == seg){
						point = <point>{joint.pointNumber}</point>;
						segment.appendChild(point);
					}
				}
				outData.segmentsList.appendChild(segment);
			}
			//trace(outData.toString());
		}
		public function createCForcesList(forces:Array){
			for each (var p:ConcentratedForce in forces){
				var f:XML = <force/>
				f.@num1 = p.forceNumber;
				f.@name = p.forceName;
				f.@value = p.forceValue;
				f.@dimension = p.dimension;
				var name1:String;
				if(p.angleName == "")
				{
					name1 = p.angleValue;
				} else {
					name1 = p.angleName;
				}
				var angle:XML = <angle name={name1} value={p.angleValue} sign={p.angleSign}>
									<point>{p.anglePoints[0]}</point>
									<point>{p.anglePoints[1]}</point>
									<point>{p.anglePoints[2]}</point>
								</angle>;
				f.appendChild(angle);
				outData.cForcesList.appendChild(f);
			}
			//trace(outData.toString());
		}
		public function createDRForcesList(forces:Array){
			for each (var p:DistributedForceR in forces){
				var f:XML = <force/>
				f.@num1 = p.forceNumber1;
				f.@num2 = p.forceNumber2;
				f.@name = p.forceName;
				f.@value = p.forceValue;
				f.@dimension = p.dimension;
				f.@angle = p.angleValue;
				
				outData.drForcesList.appendChild(f);
			}
			//trace(outData.toString());
		}
		public function createDTForcesList(forces:Array){
			for each (var p:DistributedForceT in forces){
				var f:XML = <force/>
				f.@num1 = p.forceNumber1;
				f.@num2 = p.forceNumber2;
				f.@name = p.forceName;
				f.@value = p.forceValue;
				f.@dimension = p.dimension;
				f.@angle = p.angleValue;
				
				outData.dtForcesList.appendChild(f);
			}
			//trace(outData.toString());
		}
		public function createMomentsList(moments:Array){
			for each (var m:Moment in moments){
				var f:XML = <moment/>;
				f.@num1 = m.momentNumber;
				f.@name = m.momentName;
				f.@value = m.momentValue;
				f.@dimension = m.units;
				f.@isClockwise = m.isClockWise;
				
				outData.momentsList.appendChild(f);
			}
			//trace(outData.toString());
		}
		public function createLinearDimensionsList(dimensions:Array){
			for each (var d in dimensions){
				var razmer:XML = <lDimension/>;
				razmer.@type = d.razmerType;
				razmer.@name = d.razmerName;
				razmer.@value = d.razmerValue;
				razmer.@dimension = d.dimension;
				var firstPoints:XML = <firstPointsList/>;
				var secondPoints:XML = <secondPointsList/>
				
				var point_id:XML;
				
				if(d.razmerType == LinearDimensionContainer.FREE_DIMENSION){
					for each ( var element:XML in outData.pointsList.elements()){
						var a = element.@x.toString();
						var b = element.@y.toString();
						if(a == d.firstPointDecartCoord.x.toFixed(0) &&
						   b == d.firstPointDecartCoord.y.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   firstPoints.appendChild(point_id);
						}
						if(a == d.secondPointDecartCoord.x.toFixed(0) &&
						   b == d.secondPointDecartCoord.y.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   secondPoints.appendChild(point_id);
						}
					}
					razmer.appendChild(firstPoints);
					razmer.appendChild(secondPoints);
				}
				
				if(d.razmerType == LinearDimensionContainer.HORISONTAL_DIMENSION){
					for each ( element in outData.pointsList.elements()){
						a = element.@x.toString();
						if(a == d.firstPointDecartCoord.x.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   firstPoints.appendChild(point_id);
						}
						if(a == d.secondPointDecartCoord.x.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   secondPoints.appendChild(point_id);
						}
					}
					razmer.appendChild(firstPoints);
					razmer.appendChild(secondPoints);
				}
				
				if(d.razmerType == LinearDimensionContainer.VERTICAL_DIMENSION){
					for each ( element in outData.pointsList.elements()){
						a = element.@y.toString();
						if(a == d.firstPointDecartCoord.y.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   firstPoints.appendChild(point_id);
						}
						if(a == d.secondPointDecartCoord.y.toFixed(0) ){
							   point_id = <point id={element.@id}/>
							   secondPoints.appendChild(point_id);
						}
					}
					razmer.appendChild(firstPoints);
					razmer.appendChild(secondPoints);
				}
				outData.lDimensionsList.appendChild(razmer);
			}
			//trace(outData.toString());
		}
		public function createAnglesList(angles:Array){
			for each (var ang:AngleDimensionContainer in angles){
				var angle:XML = <angle name={ang.razmerName} value={ang.razmerValue} isInner={ang.isInnerAngle}>
									<point>{ang.firstPointNumber}</point>
									<point>{ang.secondPointNumber}</point>
									<point>{ang.thirdPointNumber}</point>
								</angle>;
				outData.anglesList.appendChild(angle);
			}
			trace(outData.toString());
		}
		public function createJointsList(opora1:Array, opora2:FixedJointContainer, opora3:SealingContainer){
			if(opora3 != null){
				var joint:XML = <sealing/>;
				joint.@id = opora3.pointNumber;
				joint.@Rx = opora3.horisontalReaction;
				joint.@Ry = opora3.verticalReaction;
				joint.@M = opora3.moment;
				outData.appendChild(joint);
			}
			if(opora2 != null){
				joint = <fixedJoint/>;
				joint.@id = opora2.pointNumber;
				joint.@Rx = opora2.horisontalReaction;
				joint.@Ry = opora2.verticalReaction;
				outData.appendChild(joint);
			}
			if(opora1.length != 0){
				for each ( var j:MovableJointContainer in opora1){
					joint = <movableJoint id={j.pointNumber} R={j.reaction}/>;
					var angle:XML = <angle name={j.angle} value={j.angleValue} sign={j.angleSign}>
										<point>{j.firstPointOfAngle}</point>
										<point>{j.secondPointOfAngle}</point>
										<point>{j.thirdPointOfAngle}</point>
									</angle>
					joint.appendChild(angle);
					outData.jointsList.appendChild(joint);
				}
			}
		}
		public function get data():String/*XML*/{
			return '<?xml version="1.0" encoding="utf-8" ?>' + this.outData.toXMLString();
		}
	}
	
}
