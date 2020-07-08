class Scheduling
    attr_accessor :burst, :arrival, :quantum, :burst_, :before, :after, :indexes

    def initialize(burst, arrival, quantum)

        if burst.length != arrival.length
            raise "Size of burst array and arrival time are different!"
        else
            @burst = burst
            @arrival = arrival
            @quantum = quantum

            @burst_ = burst[0 .. burst.length]
            @before = []
            @after = []
            @indexes = []
        end
    end

    def controlAllBurst
        temp = true

        for value in @burst do
            if value == 0
                temp = temp & true
            else
                temp = temp & false
            end
        end

        return temp
    end

    def RoundRobin
        temp = 0

        while !controlAllBurst
            for i in 0..(@burst.length-1) do
                if @burst[i] >= @quantum
                    @burst[i] -= @quantum
                    puts "P%d = %d     %d => %d" % [i, @quantum, temp, temp + @quantum]
                    @before.push(temp)
                    @indexes.push(i)
                    temp += @quantum
                    @after.push(temp)
                elsif @burst[i] < quantum && burst[i] != 0
                    puts "P%d = %d     %d => %d" % [i, @burst[i], temp, temp + @burst[i]]
                    @before.push(temp)
                    @indexes.push(i)
                    temp += @burst[i]
                    @burst[i] = 0
                    @after.push(temp)
                end
            end
        end

        puts "Total Burst Time: %d ms" % [temp]
    end

    def findLastIndex(array, value)
        for i in 1..array.length do
            if array[array.length - i] == value
                return array.length - i
            end
        end

        return -1
    end

    def FindWaitingTime(pIndex)
        index = findLastIndex(@indexes, pIndex)
        temp = @after[index]

        return temp - @burst_[pIndex] - @arrival[pIndex]
    end

    def AverageWaitingTime
        avg = 0

        for i in 0..(@burst.length - 1) do
            avg += FindWaitingTime(i)
        end

        return avg * 1.0 / @burst.length
    end

    def FindTurnaroundTime(pIndex)
        return @burst_[pIndex] + FindWaitingTime(pIndex)
    end

    def AverageTurnaroundTime
        avg = 0

        for i in 0..(@burst.length - 1) do
            avg += FindTurnaroundTime(i)
        end

        return avg * 1.0 / @burst.length
    end

    def FindResponseTime(pIndex)
        return @before[pIndex] - @arrival[pIndex]
    end

    def AverageResponseTime
        avg = 0

        for i in 0..(@burst.length - 1) do
            avg += FindResponseTime(i)
        end

        return avg * 1.0 / @burst.length
    end
end

burst = [10, 8, 7, 5]
arrival = [0, 0, 2, 2]

quantum = 5

RR = Scheduling.new(burst, arrival, quantum)
RR.RoundRobin

puts "\n    Waiting Time\tTurnaround Time\t\tResponse Time"
for i in 0..(burst.length - 1) do
    puts "P%d  %d ms \t\t\t%d ms\t\t\t\t%d ms" % [i, RR.FindWaitingTime(i), RR.FindTurnaroundTime(i), RR.FindResponseTime(i)]
end

puts "\nAverage Waiting Time: %.2f ms" % [RR.AverageWaitingTime()]
puts "Average Response Time: %.2f ms" % [RR.AverageResponseTime()]
puts "Average Turnaround Time: %.2f ms" % [RR.AverageTurnaroundTime()]