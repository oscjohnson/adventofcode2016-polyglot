import java.security.MessageDigest
import scala.util.matching.Regex
import scala.util.control.Breaks._

object Main extends App {
  var hashes = Map[String, String]()

  println(run("ihaygndm", false))

  def run(salt: String = "abc", part2: Boolean = false): Int = {
    var index = 0
    var stretch = if (part2) 2016 else 0
    var keys = Array.empty[(String, Int)]

    while (keys.length < 64) {
      val hash = md5(salt + index, stretch)

      ("(.)\\1\\1".r findFirstIn hash) match {
        case Some(matching) => {
          var j = index + 1
          breakable { while (j < (index + 1000)) {
            var fiveTimesPattern = (matching.substring(0,1) * 5).r
            var candidate = md5(salt + j, stretch)
            if ((fiveTimesPattern findAllIn candidate).length > 0) {
              if (!(keys contains (candidate, j))) {
                keys = keys :+ (hash, index)
                break
              }
            }
            j += 1
          } }
        } 
        case None => {}
      }

      index += 1
    }

    keys.last._2
  }

  def md5(s: String, times: Int): String = {
    if (hashes contains s) {
      return hashes(s)
    }
    var hash = s
    for( i <- 0 to times) {
      hash = MessageDigest.getInstance("MD5").digest(hash.getBytes).map("%02x".format(_)).mkString
    }
    hashes += (s -> hash)

    hash
  }
}