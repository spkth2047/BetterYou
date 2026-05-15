import SwiftUI
import Charts
import SwiftData

struct WeightChartView: View {
    @Query(sort: \WeightLog.date) private var weightLogs: [WeightLog]

    private var recentLogs: [WeightLog] {
        Array(weightLogs.suffix(12))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Body Weight")
                .font(AppTheme.title(17))
                .foregroundStyle(AppTheme.textPrimary)

            if recentLogs.isEmpty {
                Text("No weight data yet")
                    .font(AppTheme.body())
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
            } else {
                Chart(recentLogs) { log in
                    LineMark(
                        x: .value("Date", log.date),
                        y: .value("Weight", log.weightKg)
                    )
                    .foregroundStyle(AppTheme.accent)
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Date", log.date),
                        y: .value("Weight", log.weightKg)
                    )
                    .foregroundStyle(AppTheme.accent)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisValueLabel()
                            .foregroundStyle(AppTheme.textSecondary)
                        AxisGridLine()
                            .foregroundStyle(AppTheme.textSecondary.opacity(0.2))
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .frame(height: 180)
            }
        }
    }
}
