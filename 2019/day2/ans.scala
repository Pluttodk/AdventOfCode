import scala.io.Source

val v = Source.fromFile("1.in")
    .getLines()
    .take(1)
    .mkString("\n")
    .split(",")
    .map(_.toInt)
    .zipWithIndex
    .foldRight (List[List[Int]]()) ((a, acc) => 
        if(a._2 % 4 == 0) 
            List(a._1)::acc 
        else 
            (a._1::acc.head)::acc)
    .filter(_.length == 4)
    .

println(v)
