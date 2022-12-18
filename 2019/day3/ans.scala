import scala.io.Source

val v = Source.fromFile("3.in")
    .getLines()
    .take(2)
    .mkString("\n")
    .split("\n")
    .map(v => 
        v.split(",")
        .foldRight(List[(Int,Int)]((0,0)))((s,acc) =>
            if(s.take(1).mkString("\n") == "U"){
                (acc.reverse.head._2 to (s.drop(1)
                .reverse
                .zipWithIndex
                .foldRight(0.0)((a,acc) => 
                    (Math.pow(10,a._2)*a._1.toInt)+acc).toInt)
                ).map(v => (acc.reverse.head._1,v))
                .toList ++ acc
            } else if(s.take(1).mkString("\n") == "D") {
                (acc.reverse.head._2 to (s.drop(1)
                .reverse
                .zipWithIndex
                .foldRight(0.0)((a,acc) => 
                    (Math.pow(10,a._2)*a._1.toInt)+acc).toInt)
                by -1
                ).map(v => (acc.reverse.head._1,v))
                .toList ++ acc
            } else if(s.take(1).mkString("\n") == "D") {
                (acc.reverse.head._1 to (s.drop(1)
                .reverse
                .zipWithIndex
                .foldRight(0.0)((a,acc) => 
                    (Math.pow(10,a._2)*a._1.toInt)+acc).toInt)
                ).map(v => (v,acc.reverse.head._2))
                .toList ++ acc
            } else {
                (acc.reverse.head._1 to (s.drop(1)
                .reverse
                .zipWithIndex
                .foldRight(0.0)((a,acc) => 
                    (Math.pow(10,a._2)*a._1.toInt)+acc).toInt)
                by -1
                ).map(v => (v,acc.reverse.head._2))
                .toList ++ acc
            }
        )
    )

v.map(println(_))
